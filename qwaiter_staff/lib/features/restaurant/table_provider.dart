import 'package:flutter/material.dart';
import 'package:qwaiter_staff/features/restaurant/table_service.dart';

enum TableStatus { idle, loading, error }

class Table {
  final String tableID;
  final String restaurantID;
  final String tableName;
  final String QRCodeToken;
  final String authCode;

  const Table({
    required this.tableID,
    required this.restaurantID,
    required this.tableName,
    required this.QRCodeToken,
    required this.authCode,
  });

  factory Table.fromJson(Map<String, dynamic> json) => Table(
    tableID: json['tableID'],
    restaurantID: json['restaurantID'],
    tableName: json['tableName'],
    QRCodeToken: json['QRCodeToken'],
    authCode: json['authCode'],
  );
}

class TableProvider extends ChangeNotifier {
  final TableService _service = TableService();
  String? _restaurantID;
  String get restaurantID => _restaurantID ?? '';

  TableStatus status = TableStatus.idle;
  String? errorMessage;
  List<Table> tables = [];

  void setRestaurantID(String id) {
    _restaurantID = id;
    notifyListeners();
  }

  bool get isInitialized => _restaurantID != null && _restaurantID!.isNotEmpty;

  void _setState(TableStatus s, [String? error]) {
    status = s;
    errorMessage = error;
    notifyListeners();
  }

  Future<void> fetchTables() async {
    if (!isInitialized) {
      _setState(TableStatus.error, 'Restaurant ID is not set');
      return;
    }

    _setState(TableStatus.loading);
    try {
      final data = await _service.getTables(restaurantID);
      tables = data.map((e) => Table.fromJson(e)).toList();
      _setState(TableStatus.idle);
    } catch (e) {
      _setState(TableStatus.error, e.toString());
    }
  }

  Future<bool> createTable(
    String restaurantID,
    String tableName,
    String authCode,
  ) async {
    if (!isInitialized) {
      _setState(TableStatus.error, 'Restaurant ID is not set');
      return false;
    }

    _setState(TableStatus.loading);
    try {
      final data = await _service.createTable(
        restaurantID,
        tableName,
        authCode,
      );
      await fetchTables();
      return true;
    } catch (e) {
      _setState(TableStatus.error, e.toString());
      return false;
    }
  }

  Future<bool> updateTable(
    String restaurantID,
    String tableID,
    String? tableName,
    String? authCode,
  ) async {
    if (!isInitialized) {
      _setState(TableStatus.error, 'Restaurant ID is not set');
      return false;
    }

    _setState(TableStatus.loading);
    try {
      await _service.updateTable(restaurantID, tableID, tableName, authCode);
      await fetchTables();
      return true;
    } catch (e) {
      _setState(TableStatus.error, e.toString());
      return false;
    }
  }
}
