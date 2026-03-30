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

  WorkerStatus status = WorkerStatus.idle;
  String? errorMessage;
  List<Worker> workers = [];
}
