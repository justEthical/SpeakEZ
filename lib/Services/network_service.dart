import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Constants/posthog_events.dart';

class NetworkService {
  static final dio = Dio();
  static final groqBaseUrl = "https://api.groq.com/openai/v1/chat/completions";
  static final baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent?key=AIzaSyBcc-zdYdnImr7fk5PJJvYjizsSkScrOKs';
  static Future<String> getUserCountryFromIP() async {
    final response = await http.get(Uri.parse("https://ipwho.is/"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      return data["country_code"]; // e.g., "IN"
    } else {
      return "Unknown";
    }
  }

  static Future<String?> getAiReposne(
    String userPrompt, {
    required String topic,
    required List<Map<String, dynamic>> pastConversation,
  }) async {
    final pastConversationSring = jsonEncode(
      pastConversation.reversed.toList(),
    );
    final systemPrompt =
        "${AppStrings.systemPrompt} : $topic. PAST CONVERSATION: $pastConversationSring. ${AppStrings.continueConversation}";
    try {
      final body = getBody(systemPrompt, userPrompt);
      Response response = await dio.post(baseUrl, data: jsonEncode(body));
      if (response.statusCode == 200) {
        return response.data['candidates'][0]['content']['parts'][0]['text'];
      }
    } on DioException catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.apiCallFailed,
        errorMessage: 'Dio error: ${e.message}',
        location: 'NetworkService.getAiReposne',
        additionalProperties: {'api': 'gemini', 'topic': topic},
      );
      print('Dio error: ${e.message}');
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.networkError,
        errorMessage: 'Other error: $e',
        location: 'NetworkService.getAiReposne',
        additionalProperties: {'api': 'gemini', 'topic': topic},
      );
      print('Other error: $e');
    }
    return null;
  }

  static Future<String?> getConversationAiFeedbackResult(
    List<Map<String, dynamic>> pastConversation,
  ) async {
    try {
      final text = jsonEncode(pastConversation);
      final body = getBody(
        "${AppStrings.resultScreenSystemPrompt} user english level: ${globalController.userProfile.value.currentEnglishLevel}",
        text,
        responseMimeType: "application/json",
      );
      Response response = await dio.post(baseUrl, data: jsonEncode(body));
      if (response.statusCode == 200) {
        return response.data['candidates'][0]['content']['parts'][0]['text'];
      }
    } on DioException catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.apiCallFailed,
        errorMessage: 'Dio error: ${e.message}',
        location: 'NetworkService.getConversationAiFeedbackResult',
        additionalProperties: {'api': 'gemini'},
      );
      print('Dio error: ${e.message}');
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.networkError,
        errorMessage: 'Other error: $e',
        location: 'NetworkService.getConversationAiFeedbackResult',
        additionalProperties: {'api': 'gemini'},
      );
      print('Other error: $e');
    }
    return null;
  }

  static Map getBody(
    String systemPrompt,
    String userPrompt, {
    String responseMimeType = "text/plain",
  }) {
    return {
      "system_instruction": {
        "parts": [
          {"text": systemPrompt},
        ],
      },
      "contents": [
        {
          "parts": [
            {"text": userPrompt},
          ],
        },
      ],
      "generationConfig": {
        "temperature": 1.0,
        "responseMimeType": responseMimeType,
      },
    };
  }

  

  static Future<String?> getAiResponseFromGroq({
    required String userReply,
    required String topic,
    required  String lastAiMessage, // test also after removing it
    required  String summary
  }) async {
    final pastConversationEncoded = jsonEncode({'ai': lastAiMessage, 'user': userReply});
    final systemPrompt =
        "${AppStrings.systemPrompt2} . TOPIC: $topic.\n English level: ${globalController.userProfile.value.currentEnglishLevel}. SUMMARY: $summary";
    try {
      final body = getBodyForGroq(systemPrompt, pastConversationEncoded);
      Response response = await dio.post(
        groqBaseUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${dotenv.env['GROQ_API_KEY']??''}',
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
        location: 'NetworkService.getAiResponseFromGroq',
        additionalProperties: {'api': 'groq', 'topic': topic},
      );
      print('Dio error: ${e.message}');
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.networkError,
        errorMessage: 'Other error: $e',
        location: 'NetworkService.getAiResponseFromGroq',
        additionalProperties: {'api': 'groq', 'topic': topic},
      );
      print('Other error: $e');
    }
    return null;
  }

  static Map getBodyForGroq(systemPrompt, userPrompt, { bool isfromResultGeneration = false}) {
    final response = {
      "messages": [
        {"role": "system", "content": systemPrompt},
        {"role": "user", "content": userPrompt},
      ],
      "model": "gemma2-9b-it",
      "temperature": 1,
      "max_completion_tokens": 500,
      "top_p": 1,
      "stream": false,
      "stop": null,
      "response_format": {'type': 'json_object'}
    };
    if(isfromResultGeneration){
      response['model'] = 'gemma2-9b-it';
      response['max_completion_tokens'] = 1000;
      // response['reasoning_effort'] = 'medium';
      response['response_format'] = {'type': 'json_object'};
    }
    return response;
  }


static Future<String?> getConversationAiFeedbackResultFromGroq(
    List<Map<String, dynamic>> pastConversation,
  ) async {
    final pastConversationEncoded = jsonEncode(pastConversation);
    final systemPrompt =
        "${AppStrings.resultScreenSystemPrompt} user english level: ${globalController.userProfile.value.currentEnglishLevel}";
    try {
      final body = getBodyForGroq(systemPrompt, pastConversationEncoded, isfromResultGeneration: true);
      Response response = await dio.post(
        groqBaseUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${dotenv.env['GROQ_API_KEY']??''}',
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
        location: 'NetworkService.getConversationAiFeedbackResultFromGroq',
        additionalProperties: {'api': 'groq'},
      );
      print('Dio error: ${e.message}'); 
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.networkError,
        errorMessage: 'Other error: $e',
        location: 'NetworkService.getConversationAiFeedbackResultFromGroq',
        additionalProperties: {'api': 'groq'},
      );
      print('Other error: $e'); 
    }
     return null;
  }

}
