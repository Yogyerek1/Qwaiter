import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  Future<bool> workerLogin(String username, String password) async {
    try {
      await _dio.post(
        '/auth/worker-login',
        data: {'username': username, 'password': password},
      );
      return true;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Login failed';
    }
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }

  Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await _dio.get('/auth/me');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to fetch user';
    }
  }

  Future<bool> ownerLogin(String email, String password) async {
    try {
      await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return true;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Login failed';
    }
  }

  Future<bool> verifyLogin(String email, String code) async {
    try {
      await _dio.post(
        '/auth/verify-login',
        data: {'email': email, 'code': code},
      );
      return true;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Verification failed';
    }
  }
}
