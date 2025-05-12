import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = 'YOUR_API_KEY_HERE';
  final String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/chat-bison-001:generateContent?key=';

  Future<String> getGeminiResponse(String prompt) async {
    final url = Uri.parse('$apiUrl$apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('Failed to get response from Gemini: ${response.body}');
    }
  }
}
