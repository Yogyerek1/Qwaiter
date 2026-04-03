import 'package:dio/dio.dart';
import 'package:qwaiter_staff/core/network/dio_client.dart';

class TableService {
  final Dio _dio = DioClient().dio;

  Future<List<dynamic>> getTables(String restaurantID) async {
    try {
      final response = await _dio.get('/user/tables/$restaurantID');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to fetch tables';
    }
  }

  Future<bool> createTable(
    String restaurantID,
    String tableName,
    String authCode,
  ) async {
    try {
      final response = await _dio.post(
        '/user/create/table',
        data: {
          'restaurantID': restaurantID,
          'tableName': tableName,
          'authCode': authCode,
        },
      );
      return true;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to create table';
    }
  }
}
