import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  /// Sends an image file to the backend for disease prediction
  /// Returns a Map with 'class' and 'confidence' keys
  static Future<Map<String, dynamic>> predictDisease(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/predict'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception('Failed to predict disease. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error communicating with server: $e');
    }
  }

  /// Checks if the backend is available
  static Future<bool> isBackendAvailable() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/ping'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}