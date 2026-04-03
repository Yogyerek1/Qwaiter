import 'package:flutter/material.dart';
import 'package:qwaiter_staff/features/restaurant/menu_service.dart';

enum MenuStatus { idle, loading, error }

class Category {
  final String id;
  final String name;
  final int displayOrder;
  final List<MenuItem> items;

  const Category({
    required this.id,
    required this.name,
    required this.displayOrder,
    required this.items,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    name: json['name'],
    displayOrder: json['displayOrder'],
    items: (json['items'] as List? ?? [])
        .map((item) => MenuItem.fromJson(item))
        .toList(),
  );
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final String price;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    price: json['price'],
  );
}

class MenuProvider extends ChangeNotifier {
  final MenuService _service = MenuService();
  String? _restaurantID;
  String get restaurantID => _restaurantID ?? '';

  MenuStatus status = MenuStatus.idle;
  String? errorMessage;
  List<Category> categories = [];
  List<MenuItem> get menuItems => categories.expand((c) => c.items).toList();

  void setRestaurantID(String id) {
    _restaurantID = id;
    notifyListeners();
  }

  bool get isInitialized => _restaurantID != null && _restaurantID!.isNotEmpty;

  void _setState(MenuStatus s, [String? error]) {
    status = s;
    errorMessage = error;
    notifyListeners();
  }

  Future<void> fetchMenu() async {
    if (!isInitialized) {
      _setState(MenuStatus.error, 'Restaurant ID is not set');
      return;
    }

    _setState(MenuStatus.loading);
    try {
      final data = await _service.getMenu(restaurantID);
      categories = data.map((e) => Category.fromJson(e)).toList();
      _setState(MenuStatus.idle);
    } catch (e) {
      _setState(MenuStatus.error, e.toString());
    }
  }

  Future<bool> createCategory(String categoryName, int displayOrder) async {
    if (!isInitialized) {
      _setState(MenuStatus.error, 'Restaurant ID is not set');
      return false;
    }

    _setState(MenuStatus.loading);
    try {
      await _service.createCategory(restaurantID, categoryName, displayOrder);
      await fetchMenu();
      _setState(MenuStatus.idle);
      return true;
    } catch (e) {
      _setState(MenuStatus.error, e.toString());
      return false;
    }
  }

  Future<bool> deleteCategory(String restaurantID, String categoryID) async {
    if (!isInitialized) {
      _setState(MenuStatus.error, 'Restaurant ID is not set');
      return false;
    }

    _setState(MenuStatus.loading);
    try {
      await _service.deleteCategory(restaurantID, categoryID);
      await fetchMenu();
      _setState(MenuStatus.idle);
      return true;
    } catch (e) {
      _setState(MenuStatus.error, e.toString());
      return false;
    }
  }

  Future<bool> updateCategory(
    String categoryID,
    String? name,
    int? displayOrder,
  ) async {
    if (!isInitialized) {
      _setState(MenuStatus.error, 'Restaurant ID is not set');
      return false;
    }

    _setState(MenuStatus.loading);
    try {
      await _service.updateCategory(
        restaurantID,
        categoryID,
        name,
        displayOrder,
      );
      await fetchMenu();
      _setState(MenuStatus.idle);
      return true;
    } catch (e) {
      _setState(MenuStatus.error, e.toString());
      return false;
    }
  }

  Future<bool> createMenuItem(
    String categoryID,
    String name,
    String description,
    int price,
  ) async {
    if (!isInitialized) {
      _setState(MenuStatus.error, 'Restaurant ID is not set');
      return false;
    }

    _setState(MenuStatus.loading);
    try {
      await _service.createMenuItem(
        restaurantID,
        categoryID,
        name,
        description,
        price,
      );
      await fetchMenu();
      _setState(MenuStatus.idle);
      return true;
    } catch (e) {
      _setState(MenuStatus.error, e.toString());
      return false;
    }
  }
}
