import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Constants/posthog_events.dart';

class NetworkService {
  static final dio = Dio();
  static final baseUrl =
      'https://api.deepinfra.com/v1/openai/chat/completions';
  static Future<String> getUserCountryFromIP() async {
    try {
      final response = await dio.get("https://ipwho.is/");

      if (response.statusCode == 200) {
        final data = response.data is String
            ? json.decode(response.data)
            : response.data; // Dio may already parse JSON

        print(data);
        return data["country_code"] ?? "IN"; // e.g., "IN"
      } else {
        return "IN";
      }
    } catch (e) {
      print("Error fetching country: $e");
      return "Unknown";
    }
  }


  static Map getBody(
    String systemPrompt,
    String userPrompt) {
    return {
      "model": "mistralai/Mistral-Small-3.2-24B-Instruct-2506", // "google/gemma-3-12b-it", //
      "messages": [
        {
            "role": 'system',
            "content": systemPrompt,
        },
        {
          "role": "user",
          "content": userPrompt
        },
      ],
      "response_format": { "type": "json_object" },
      "temperature": 0,
      "seed": 7
    };
  }

  static Future<String?> getAiResponse({
    required String userReply,
    required String topic,
    required  String lastAiMessage, // test also after removing it
    required  String summary
  }) async {
    final pastConversationEncoded = jsonEncode({'ai': lastAiMessage, 'user': userReply});
    final systemPrompt =
        "${AppStrings.systemPrompt2} . TOPIC: $topic.\n English level: ${globalController.userProfile.value.currentEnglishLevel}. SUMMARY: $summary";
    try {
      final body = getBody(systemPrompt, pastConversationEncoded);
      Response response = await dio.post(
        baseUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${dotenv.env['DEEP_INFRA_API_KEY']??''}',
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode(body),
      );
      // print(response.data);
      if (response.statusCode == 200) {
        return response.data['choices'][0]['message']['content'];
      }
    } on DioException catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.apiCallFailed,
        errorMessage: 'Dio error: ${e.message}',
        location: 'NetworkService.getAiResponse',
        additionalProperties: {'api': 'DeepInfra', 'topic': topic},
      );
      print('Dio error: ${e.message}');
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.networkError,
        errorMessage: 'Other error: $e',
        location: 'NetworkService.getAiResponse',
        additionalProperties: {'api': 'DeepInfra', 'topic': topic},
      );
      print('Other error: $e');
    }
    return null;
  }

static Future<String?> getConversationAiFeedbackResult(
   {required Map scoreMap, required List<String> feedbackList}
  ) async {
    final userPrompt = jsonEncode({'scoreMap': scoreMap, 'feedbackList': feedbackList});
    final systemPrompt =
        "${AppStrings.resultScreenSystemPrompt} user english level: ${globalController.userProfile.value.currentEnglishLevel}";
    try {
      final body = getBody(systemPrompt, userPrompt);
      Response response = await dio.post(
        baseUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${dotenv.env['DEEP_INFRA_API_KEY']??''}',
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode(body),
      );
      print(response.data);
      if (response.statusCode == 200) {
        return response.data['choices'][0]['message']['content'];
      }
    } on DioException catch (e) { 
      PostHogService.instance.captureError(
        PostHogEvents.apiCallFailed,
        errorMessage: 'Dio error: ${e.message}',
        location: 'NetworkService.getAiResponse',
        additionalProperties: {'api': 'DeepInfra'},
      );
      print('Dio error: ${e.message}'); 
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.networkError,
        errorMessage: 'Other error: $e',
        location: 'NetworkService.getAiResponse',
        additionalProperties: {'api': 'DeepInfra'},
      );
      print('Other error: $e'); 
    }
     return null;
  }
}
