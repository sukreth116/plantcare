import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantcare/core/constants/api_constants.dart';

class GeminiChatService {
  static Future<String> getChatbotReply(String prompt) async {
    final apiUrl = '${ApiConstants.geminiBaseUrl}${ApiConstants.geminiApiKey}';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final reply = data['candidates'][0]['content']['parts'][0]['text'];
      return reply.trim();
    } else {
      return 'Sorry, something went wrong.';
    }
  }
}
