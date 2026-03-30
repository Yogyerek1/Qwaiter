import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qwaiter_staff/core/network/dio_client.dart';

class WorkerService extends ChangeNotifier {
  final Dio _dio = DioClient().dio;

  Future<List<dynamic>> getWorkers(String restaurantID) async {
    try {
      final response = await _dio.get('/user/staff/$restaurantID');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to fetch workers';
    }
  }
}
