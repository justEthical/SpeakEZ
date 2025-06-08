import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:speak_ez/Constants/app_strings.dart';

class NetworkService {
  static final dio = Dio();
  static final baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyBcc-zdYdnImr7fk5PJJvYjizsSkScrOKs';
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
    required List<Map<String, String>> pastConversation,
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

  static Map getBody(String systemPrompt, String userPrompt) {
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
    };
  }
}
