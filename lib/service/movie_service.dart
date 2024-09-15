import 'dart:convert';
import 'package:budventure/constant/const.dart';
import 'package:budventure/model/api_response_model.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  // Centralized error handling based on status code
  ApiResponse<T> _handleStatusCode<T>(int statusCode, String responseBody) {
    switch (statusCode) {
      case 200:
      case 201:
        return ApiResponse<T>();
      case 401:
        return ApiResponse<T>(
            success: false, error: 'Unauthorized: Please log in again.');
      case 403:
        return ApiResponse<T>(
            success: false, error: 'Forbidden: You do not have permission.');
      case 413:
        return ApiResponse<T>(
            success: false, error: 'Request Entity Too Large.');
      case 500:
        return ApiResponse<T>(success: false, error: 'Internal Server Error.');
      case 503:
        return ApiResponse<T>(
            success: false,
            error: 'Service Unavailable: Please try again later.');
      default:
        return ApiResponse<T>(
            success: false, error: 'Unexpected error: $statusCode');
    }
  }

  Future<ApiResponse> get<T>(
      {required String endpoint,
        Map<String, String>? headers,
        required T Function(Map<String, dynamic>) fromJson}) async {
    try {
      final response = await http.get(
        Uri.parse("$apiBaseUrl$endpoint"),
        headers: headers ?? {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return ApiResponse<T>(data: fromJson(data));
      } else {
        return _handleStatusCode<T>(response.statusCode, response.body);
      }
    } catch (e) {
      return ApiResponse<T>(success: false, error: e.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> post(String endpoint,
      {Map<String, dynamic>? body,
        Map<String, String>? headers,
        Function(Map<String, dynamic>)? fromJson}) async {
    try {
      final response = await http.post(
        Uri.parse("$apiBaseUrl$endpoint"),
        headers: headers ?? {"Content-Type": "application/json"},
        body: body != null ? jsonEncode(body) : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        return ApiResponse<Map<String, dynamic>>(data: data);
      } else {
        return _handleStatusCode<Map<String, dynamic>>(
            response.statusCode, response.body);
      }
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
          success: false, error: e.toString());
    }
  }
}
