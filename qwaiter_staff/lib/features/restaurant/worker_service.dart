import 'package:dio/dio.dart';
import 'package:qwaiter_staff/core/network/dio_client.dart';
import 'package:qwaiter_staff/shared/enums/worker_role.dart';

class WorkerService {
  final Dio _dio = DioClient().dio;

  Future<List<dynamic>> getWorkers(String restaurantID) async {
    try {
      final response = await _dio.get('/user/staff/$restaurantID');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to fetch workers';
    }
  }

  Future<void> createWorker(
    String restaurantID,
    String name,
    String username,
    String password,
    WorkerRole role,
  ) async {
    try {
      final response = await _dio.post(
        '/user/create/worker',
        data: {
          'restaurantID': restaurantID,
          'name': name,
          'username': username,
          'password': password,
          'role': role,
        },
      );
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to fetch workers';
    }
  }

  Future<void> updateWorker(
    String restaurantID,
    String workerID,
    String? name,
    String? username,
    String? password,
    WorkerRole? role,
  ) async {
    try {
      final Map<String, dynamic> data = {
        'restaurantID': restaurantID,
        'workerID': workerID,
      };

      if (name != null) data['name'] = name;
      if (username != null) data['username'] = username;
      if (password != null) data['password'] = password;
      if (role != null) data['role'] = role.toString();

      final response = await _dio.post('/user/update/staff', data: data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to update worker';
    }
  }
}
