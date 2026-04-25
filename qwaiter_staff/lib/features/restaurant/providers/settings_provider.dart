import 'package:flutter/material.dart';
import 'package:qwaiter_staff/features/restaurant/services/settings_service.dart';

enum SettingsStatus { idle, loading, error }

class Restaurant {
  final String restaurantName;
  final String address;

  const Restaurant({required this.restaurantName, required this.address});

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    restaurantName: json['restaurantName'],
    address: json['address'],
  );
}

class SettingsProvider extends ChangeNotifier {
  final SettingsService _service = SettingsService();
  String? _restaurantID;
  String get restaurantID => _restaurantID ?? '';

  SettingsStatus status = SettingsStatus.idle;
  String? errorMessage;
}
