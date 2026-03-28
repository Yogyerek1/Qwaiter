import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  Future<void> workerLogin(String username, String password) async {
    await _dio.post(
      '/auth/worker-login',
      data: {'username': username, 'password': password},
    );
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await _dio.get('auth/me');
    return response.data as Map<String, dynamic>;
  }
}
