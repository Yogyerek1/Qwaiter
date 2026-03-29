import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final String restaurantId;
  const MenuScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Menu - hamarosan'));
  }
}
