import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

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
      print('Dio error: ${e.message}');
    } catch (e) {
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
      print('Dio error: ${e.message}');
    } catch (e) {
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
    required String userPrompt,
    required String topic,
    required List<Map<String, dynamic>> pastConversation,
  }) async {
    final pastConversationEncoded = jsonEncode(pastConversation);
    final systemPrompt =
        "${AppStrings.systemPrompt2} . TOPIC: $topic. PAST CONVERSATION: $pastConversationEncoded.\n English level: ${globalController.userProfile.value.currentEnglishLevel}.";
    try {
      final body = getBodyForGroq(systemPrompt, userPrompt);
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
      print('Dio error: ${e.message}');
    } catch (e) {
      print('Other error: $e');
    }
    return null;
  }

  static Map getBodyForGroq(systemPrompt, userPrompt, {String responseMimeType = "text", maxToken = 80}) {
    return {
      "messages": [
        {"role": "system", "content": systemPrompt},
        {"role": "user", "content": userPrompt},
      ],
      "model": "llama-3.1-8b-instant",
      "temperature": 1,
      "max_completion_tokens": maxToken,
      "response_format": {
           "type": responseMimeType
      },
      "top_p": 1,
      "stream": false,
      "stop": null,
    };
  }

static Future<String?> getConversationAiFeedbackResultFromGroq(
    List<Map<String, dynamic>> pastConversation,
  ) async {
    final pastConversationEncoded = jsonEncode(pastConversation);
    final systemPrompt =
        "${AppStrings.resultScreenSystemPrompt} user english level: ${globalController.userProfile.value.currentEnglishLevel}";
    try {
      final body = getBodyForGroq(systemPrompt, pastConversationEncoded, responseMimeType: "json_object", maxToken: 1000);
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
      print('Dio error: ${e.message}'); 
    } catch (e) {
      print('Other error: $e'); 
    }
     return null;
  }

}
