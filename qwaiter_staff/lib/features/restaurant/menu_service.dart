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

  Future<void> deleteCategory(String restaurantID, String categoryID) async {
    try {
      await _dio.delete(
        '/user/delete/category',
        data: {'restaurantID': restaurantID, 'categoryID': categoryID},
      );
    } on DioException catch (e) {
      e.response?.data['message'] ?? 'Failed to delete category';
    }
  }

  Future<void> updateCategory(
    String restaurantID,
    String categoryID,
    String? name,
    int? displayOrder,
  ) async {
    try {
      final Map<String, dynamic> data = {
        'restaurantID': restaurantID,
        'categoryID': categoryID,
      };

      if (name != null) data['name'] = name;
      if (displayOrder != null) data['displayOrder'] = displayOrder;

      await _dio.patch('/user/update/categories', data: data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to update category';
    }
  }

  Future<List<dynamic>> getMenu(String restaurantID) async {
    try {
      final response = await _dio.get('/user/$restaurantID/menu');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to get menu';
    }
  }

  Future<List<dynamic>> getMenuItem(
    String restaurantID,
    String menuItemID,
  ) async {
    try {
      final response = await _dio.get('/user/$restaurantID/menu');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to get menu item';
    }
  }

  Future<void> createMenuItem(
    String restaurantID,
    String categoryID,
    String name,
    String description,
    int price,
  ) async {
    try {
      await _dio.post(
        '/user/create/menuItem',
        data: {
          'restaurantID': restaurantID,
          'categoryID': categoryID,
          'name': name,
          'description': description,
          'price': price,
        },
      );
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to create menu item';
    }
  }

  Future<void> deleteMenuItem(String restaurantID, String menuItemID) async {
    try {
      await _dio.delete(
        '/user/delete/menuItem',
        data: {'restaurantID': restaurantID, 'menuItemID': menuItemID},
      );
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to delete menu item';
    }
  }

  Future<void> updateMenuItem(
    String restaurantID,
    String menuItemID,
    String categoryID,
    String? name,
    String? description,
    int? price,
  ) async {
    try {
      final Map<String, dynamic> data = {
        'restaurantID': restaurantID,
        'menuItemID': menuItemID,
        'categoryID': categoryID,
      };

      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (price != null) data['price'] = price;

      await _dio.patch('/user/update/menuItem', data: data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to update menu item';
    }
  }
}
