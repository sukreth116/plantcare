import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantcare/core/constants/api_constants.dart';

class NewsService {
  static Future<List<dynamic>> fetchPlantNews() async {
    final response = await http.get(Uri.parse(ApiConstants.newsApiUrl));
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == 'ok') {
      return data['articles'] ?? [];
    } else {
      throw Exception("Failed to load news");
    }
  }
}
