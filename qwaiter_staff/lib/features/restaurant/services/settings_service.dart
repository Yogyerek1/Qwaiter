import 'package:dio/dio.dart';
import 'package:qwaiter_staff/core/network/dio_client.dart';

class SettingsService {
  final Dio _dio = DioClient().dio;

  Future<void> updateRestaurant(
    String restaurantID,
    String? restaurantName,
    String? address,
  ) async {
    try {
      final Map<String, dynamic> data = {};

      if (restaurantName != null) data['restaurantName'] = restaurantName;
      if (address != null) data['address'] = address;

      await _dio.post('/user/update/restaurant/$restaurantID', data: data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to update restaurant';
    }
  }

  Future<List<dynamic>> getRestaurant(String restaurantID) async {
    try {
      final response = await _dio.get('/user/restaurant/$restaurantID');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to fetch restaurant';
    }
  }
}
