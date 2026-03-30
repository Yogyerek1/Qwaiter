import 'package:flutter/material.dart';
import 'package:qwaiter_staff/features/restaurant/worker_service.dart';
import 'package:qwaiter_staff/shared/enums/worker_role.dart';

enum WorkerStatus { idle, loading, error }

class Worker {
  final String id;
  final String name;
  final String username;
  final WorkerRole role;

  const Worker({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
  });

  factory Worker.fromJson(Map<String, dynamic> json) => Worker(
    id: json['id'],
    name: json['name'],
    username: json['username'],
    role: WorkerRole.values.firstWhere(
      (r) =>
          r.name.toLowerCase() ==
          (json['role']?.toString().toLowerCase() ?? ''),
      orElse: () => WorkerRole.waiter,
    ),
  );
}

class WorkerProvider extends ChangeNotifier {
  final WorkerService _service = WorkerService();
  String? _restaurantID;
  String get restaurantID => _restaurantID ?? '';

  WorkerStatus status = WorkerStatus.idle;
  String? errorMessage;
  List<Worker> workers = [];

  void setRestaurantID(String id) {
    _restaurantID = id;
    notifyListeners();
  }

  bool get isInitialized => _restaurantID != null && _restaurantID!.isNotEmpty;

  void _setState(WorkerStatus s, [String? error]) {
    status = s;
    errorMessage = error;
    notifyListeners();
  }

  Future<void> fetchWorkers() async {
    if (!isInitialized) {
      _setState(WorkerStatus.error, "Restaurant ID is not set");
      return;
    }

    _setState(WorkerStatus.loading);
    try {
      final data = await _service.getWorkers(restaurantID);
      workers = data.map((e) => Worker.fromJson(e)).toList();
      _setState(WorkerStatus.idle);
    } catch (e) {
      _setState(WorkerStatus.error, e.toString());
    }
  }

  Future<bool> createWorker(
    String name,
    String username,
    String password,
    WorkerRole role,
  ) async {
    if (!isInitialized) {
      _setState(WorkerStatus.error, "Restaurant ID is not set");
      return false;
    }

    _setState(WorkerStatus.loading);
    try {
      final data = await _service.createWorker(
        restaurantID,
        name,
        username,
        password,
        role,
      );
      await fetchWorkers();
      _setState(WorkerStatus.idle);
      return true;
    } catch (e) {
      _setState(WorkerStatus.error, e.toString());
      return false;
    }
  }

  Future<bool> updateWorker(
    String workerID,
    String? name,
    String? username,
    String? password,
    WorkerRole? role,
  ) async {
    if (!isInitialized) {
      _setState(WorkerStatus.error, "Restaurant ID is not set");
      return false;
    }

    _setState(WorkerStatus.loading);
    try {
      await _service.updateWorker(
        restaurantID,
        workerID,
        name,
        username,
        password,
        role,
      );
      await fetchWorkers();
      _setState(WorkerStatus.idle);
      return true;
    } catch (e) {
      _setState(WorkerStatus.error, e.toString());
      return false;
    }
  }

  Future<void> deleteWorker(String workerID) async {
    if (!isInitialized) {
      _setState(WorkerStatus.error, "Restaurant ID is not set");
      return;
    }

    _setState(WorkerStatus.loading);
    try {
      _service.deleteWorker(restaurantID, workerID);
      await fetchWorkers();
      _setState(WorkerStatus.idle);
    } catch (e) {
      _setState(WorkerStatus.error, e.toString());
    }
  }
}
