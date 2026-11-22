import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantcare/core/constants/api_constants.dart';

class DiseaseDetectionService {
  static Future<Map<String, dynamic>> predictDisease(String imagePath) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(ApiConstants.flaskPredictUrl));
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        try {
          return json.decode(response.body) as Map<String, dynamic>;
        } catch (e) {
          return {'error': 'Invalid response format from server.'};
        }
      } else {
        return {
          'error': 'Prediction failed with status ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
