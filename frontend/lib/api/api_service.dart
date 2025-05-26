import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:punctualis_1/api/metrica.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://194.58.126.4:8080/';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _tokenKey = 'jwt_token';

  ApiService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: _tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          await _storage.delete(key: _tokenKey);
        }
        return handler.next(e);
      },
    ));
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  Future<String?> login(String email, String password,
      bool savePassword) async {
    try {
      final response = await _dio.post(
        '/Auth/Login',
        data: jsonEncode({
          'email': email,
          'password': password,
        }),
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      final token = response.data['access_token'];
      Metrica.loginSuccess();
      if (savePassword) {
        await _storage.write(key: _tokenKey, value: token);
      }
      return token;
    } on DioException catch (e) {
      Metrica.loginFail();
      throw Exception(e.response?.data['detail'] ?? 'Login failed');
    }
  }

  Future<void> register(String firstName, String secondName, String email,
      String password) async {
    try {
      await _dio.post(
        '/Auth/Registration',
        data: jsonEncode({
          'first_name': firstName,
          'second_name': secondName,
          'email': email,
          'password': password
        }),
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Registration failed');
    }
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