import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final String restaurantId;
  const SettingsScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings - hamarosan'));
  }
}
