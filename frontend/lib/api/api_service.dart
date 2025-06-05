import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:punctualis_1/api/metrica.dart';
import 'package:punctualis_1/main_app/dialogue_page.dart';
import 'package:punctualis_1/structures/task.dart';
import 'package:punctualis_1/structures/message.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ),
  );
  final String _baseUrl = 'http://194.58.126.4:8080/';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _tokenKey = 'jwt_token';

  ApiService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    _dio.interceptors.add(
      InterceptorsWrapper(
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
      ),
    );
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  Future<String?> login(
    String email,
    String password,
    bool savePassword,
  ) async {
    try {
      final response = await _dio.post(
        '/Auth/Login',
        data: jsonEncode({'email': email, 'password': password}),
        options: Options(contentType: Headers.jsonContentType),
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

  Future<void> register(
    String firstName,
    String secondName,
    String email,
    String password,
  ) async {
    try {
      await _dio.post(
        '/Auth/Registration',
        data: jsonEncode({
          'first_name': firstName,
          'second_name': secondName,
          'email': email,
          'password': password,
        }),
        options: Options(contentType: Headers.jsonContentType),
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

  Future<void> createTask(Task task) async {
    try {
      await _dio.post(
        '/Tasks/Create_task',
        data: jsonEncode({
          'title': task.title,
          'description': task.description,
          'priority': task.priority,
          'creation_date': task.creationDate,
          "finish_date": task.finishDate,
          'is_done': false,
          'time_reminder': task.timeReminder,
          'scheduled_at': task.scheduledAt,
        }),
        options: Options(contentType: Headers.jsonContentType),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Creating task failed');
    }
  }

  Future<List<dynamic>> getUserTasks() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      final response = await _dio.get(
        '/Tasks/Get_user_tasks',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch data: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> sendMessage(Message message) async {
    try {
      final token = await _storage.read(key: _tokenKey);
      final response = await _dio.post(
        '/Chat/',
        data: jsonEncode({'message': message.text}),
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: Duration(seconds: 10),
        ),
      );
      print('1');
      print(response.data);
      print(response.data.runtimeType);
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Sending message failed');
    }
  }
}
