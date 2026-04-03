import 'package:dio/dio.dart';
import 'package:qwaiter_staff/core/network/dio_client.dart';

class MenuService {
  final Dio _dio = DioClient().dio;

  Future<List<dynamic>> getCategories(String restaurantID) async {
    try {
      final response = await _dio.get('/user/categories/$restaurantID');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to get categories';
    }
  }

  Future<void> createCategory(
    String restaurantID,
    String categoryName,
    int displayOrder,
  ) async {
    try {
      await _dio.post(
        '/user/create/category',
        data: {
          'restaurantID': restaurantID,
          'categoryName': categoryName,
          'displayOrder': displayOrder,
        },
      );
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to create category';
    }
  }
}
