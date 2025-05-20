// lib/api/api_service.dart
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://194.58.126.4:8080/'; // Для эмулятора Android

  ApiService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<Map<String, dynamic>> getAllUsers() async {
    try {
      final response = await _dio.get('/Users/Get_all_users');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch data: ${e.message}');
    }
  }
}