import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/workers_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/tables_screen.dart';
import '../screens/settings_screen.dart';

class RestaurantShell extends StatefulWidget {
  final String restaurantId;
  const RestaurantShell({super.key, required this.restaurantId});

  @override
  State<RestaurantShell> createState() => _RestaurantShellState();
}

class _RestaurantShellState extends State<RestaurantShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restaurant ${widget.restaurantId}')),
      body: const Center(child: Text('Hamarosan')),
    );
  }
}
