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
    role: json['role'],
  );
}

class WorkerProvider extends ChangeNotifier {
  final WorkerService _service = WorkerService();
  final String restaurantID;

  WorkerProvider({required this.restaurantID});

  WorkerStatus status = WorkerStatus.idle;
  String? errorMessage;
  List<Worker> workers = [];

  void _setState(WorkerStatus s, [String? error]) {
    status = s;
    errorMessage = error;
    notifyListeners();
  }

  Future<void> fetchWorkers() async {
    _setState(WorkerStatus.loading);
    try {
      final data = await _service.getWorkers(restaurantID);
      workers = data.map((e) => Worker.fromJson(e)).toList();
      _setState(WorkerStatus.idle);
    } catch (e) {
      _setState(WorkerStatus.error, e.toString());
    }
  }

  Future<void> createWorker(
    String name,
    String username,
    String password,
    WorkerRole role,
  ) async {
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
    } catch (e) {
      _setState(WorkerStatus.error, e.toString());
    }
  }
}
