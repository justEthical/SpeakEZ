import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Constants/posthog_events.dart';

class NetworkService {
  static final dio = Dio();

  // All DeepInfra traffic goes through the Cloudflare proxy, which holds the
  // DeepInfra key and verifies the Firebase App Check token below.
  static final _proxyBase =
      (dotenv.env['PROXY_BASE_URL'] ?? '').replaceAll(RegExp(r'/+$'), '');
  static final baseUrl = '$_proxyBase/v1/openai/chat/completions';

  // App Check token proving the request comes from a genuine app instance.
  // getToken() can hang indefinitely when attestation fails (e.g. an
  // unregistered debug token on a fresh install), so it is bounded by a
  // timeout and never allowed to throw — a bad/absent token surfaces as a
  // failed request instead of a frozen screen.
  static const _appCheckTimeout = Duration(seconds: 10);

  static Future<Map<String, String>> _appCheckHeaders() async {
    // Debug builds authenticate to the proxy with a shared dev secret instead
    // of a Firebase App Check token, so there is no per-install debug token to
    // register. Release builds always use real App Check attestation.
    if (kDebugMode) {
      final devSecret = dotenv.env['DEV_BYPASS_SECRET'] ?? '';
      if (devSecret.isNotEmpty) {
        return {'X-Dev-Secret': devSecret};
      }
    }

    String token = '';
    try {
      token =
          await FirebaseAppCheck.instance.getToken().timeout(
            _appCheckTimeout,
          ) ??
          '';
    } on TimeoutException catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.networkError,
        errorMessage: 'App Check getToken timed out: $e',
        location: 'NetworkService._appCheckHeaders',
        additionalProperties: {'reason': 'app_check_timeout'},
      );
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.networkError,
        errorMessage: 'App Check getToken failed: $e',
        location: 'NetworkService._appCheckHeaders',
        additionalProperties: {'reason': 'app_check_error'},
      );
    }
    return {'X-Firebase-AppCheck': token};
  }

  static Future<String> getUserCountryFromIP() async {
    try {
      final response = await dio.get("https://ipwho.is/");

      if (response.statusCode == 200) {
        final data =
            response.data is String
                ? json.decode(response.data)
                : response.data; // Dio may already parse JSON

        return data["country_code"] ?? "IN"; // e.g., "IN"
      } else {
        return "IN";
      }
    } catch (e) {
      return "Unknown";
    }
  }

  static Map getBody(String systemPrompt, String userPrompt) {
    return {
      "model":
          "google/gemma-3-12b-it",
      "messages": [
        {"role": 'system', "content": systemPrompt},
        {"role": "user", "content": userPrompt},
      ],
      "response_format": { "type": "json_object" },
      "reasoning_effort": "none",
      "temperature": 0,
      "seed": 7,
    };
  }

  static Future<String?> getAiResponse({
    required String userReply,
    required String topic,
    required String lastAiMessage, // test also after removing it
    required String summary,
  }) async {
    final pastConversationEncoded = jsonEncode({
      'ai': lastAiMessage,
      'user': userReply,
    });
    final systemPrompt =
        "${AppStrings.systemPrompt2} . TOPIC: $topic.\n English level: ${globalController.userProfile.value.currentEnglishLevel}. SUMMARY: $summary";
    try {
      final body = getBody(systemPrompt, pastConversationEncoded);
      Response response = await dio.post(
        baseUrl,
        options: Options(
          headers: {
            ...await _appCheckHeaders(),
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final aiResponse = response.data['choices'][0]['message']['content'];
        return aiResponse;
      }
    } on DioException catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.apiCallFailed,
        errorMessage: 'Dio error: ${e.message}',
        location: 'NetworkService.getAiResponse',
        additionalProperties: {'api': 'DeepInfra', 'topic': topic},
      );
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.networkError,
        errorMessage: 'Other error: $e',
        location: 'NetworkService.getAiResponse',
        additionalProperties: {'api': 'DeepInfra', 'topic': topic},
      );
    }
    return null;
  }

  static Future<String?> getConversationAiFeedbackResult({
    required Map scoreMap,
    required List<String> feedbackList,
  }) async {
    final userPrompt = jsonEncode({
      'scoreMap': scoreMap,
      'feedbackList': feedbackList,
    });
    final systemPrompt =
        "${AppStrings.resultScreenSystemPrompt} user english level: ${globalController.userProfile.value.currentEnglishLevel}";
    try {
      final body = getBody(systemPrompt, userPrompt);
      Response response = await dio.post(
        baseUrl,
        options: Options(
          headers: {
            ...await _appCheckHeaders(),
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final aiResponse = response.data['choices'][0]['message']['content'];
        return aiResponse;
      }
    } on DioException catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.apiCallFailed,
        errorMessage: 'Dio error: ${e.message}',
        location: 'NetworkService.getConversationAiFeedbackResult',
        additionalProperties: {'api': 'DeepInfra'},
      );
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.networkError,
        errorMessage: 'Other error: $e',
        location: 'NetworkService.getConversationAiFeedbackResult',
        additionalProperties: {'api': 'DeepInfra'},
      );
    }
    return null;
  }

  static Future<String?> transcribeAudio(String audioFilePath) async {
    final apiUrl =
        '$_proxyBase/v1/inference/openai/whisper-large-v3-turbo';

    try {
      // Prepare the form data
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(
          audioFilePath,
          filename: audioFilePath.split(Platform.pathSeparator).last,
        ),
        'language': 'en',
      });

      // Send POST request
      final response = await dio.post(
        apiUrl,
        data: formData,
        options: Options(
          headers: await _appCheckHeaders(),
          contentType: 'multipart/form-data',
        ),
      );
      final body = response.data;
      return body['text'];
    } on DioException catch (_) {
      // Error handled silently
    }
    return null;
  }
}
