// lib/core/network/api_client.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ApiClient {
  final Dio _dio;

  ApiClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.padhai.com', // Placeholder - will be configured in production
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    ]);
  }

  Dio get dio => _dio;

  // Auth endpoints
  Future<Response<dynamic>> login(Map<String, dynamic> data) {
    return _dio.post('/auth/login', data: data);
  }

  Future<Response<dynamic>> register(Map<String, dynamic> data) {
    return _dio.post('/auth/register', data: data);
  }

  Future<Response<dynamic>> refreshToken(String token) {
    return _dio.post('/auth/refresh', data: {'refresh_token': token});
  }

  // Content endpoints
  Future<Response<dynamic>> getSubjects() {
    return _dio.get('/subjects');
  }

  Future<Response<dynamic>> getChapters(String subjectId) {
    return _dio.get('/subjects/$subjectId/chapters');
  }

  Future<Response<dynamic>> getTopics(String chapterId) {
    return _dio.get('/chapters/$chapterId/topics');
  }

  Future<Response<dynamic>> getQuestions(String chapterId, String difficulty) {
    return _dio.get(
      '/chapters/$chapterId/questions',
      queryParameters: {'difficulty': difficulty},
    );
  }

  // Progress endpoints
  Future<Response<dynamic>> syncProgress(Map<String, dynamic> data) {
    return _dio.post('/progress/sync', data: data);
  }

  Future<Response<dynamic>> submitQuizAttempt(Map<String, dynamic> data) {
    return _dio.post('/quiz/submit', data: data);
  }
}
