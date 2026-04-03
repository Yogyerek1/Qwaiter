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
      await _dio.post(
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

  Future<void> deleteTable(String restaurantID, String tableID) async {
    try {
      await _dio.delete(
        '/user/delete/table',
        data: {'restaurantID': restaurantID, 'tableID': tableID},
      );
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to delete table';
    }
  }

  Future<void> updateTable(
    String restaurantID,
    String tableID,
    String? tableName,
    String? authCode,
  ) async {
    try {
      final Map<String, dynamic> data = {
        'restaurantID': restaurantID,
        'tableID': tableID,
      };

      if (tableName != null) data['tableName'] = tableName;
      if (authCode != null) data['authCode'] = authCode;

      await _dio.post('/user/update/table', data: data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to update table';
    }
  }
}
