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
  void initState() {
    super.initState();
    _screens = [
      WorkersScreen(restaurantId: widget.restaurantId),
      MenuScreen(restaurantId: widget.restaurantId),
      TablesScreen(restaurantId: widget.restaurantId),
      SettingsScreen(restaurantId: widget.restaurantId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant'),
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Workers'),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.table_bar), label: 'Tables'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
