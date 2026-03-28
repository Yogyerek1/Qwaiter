import 'package:flutter/material.dart';

class RestaurantShell extends StatelessWidget {
  final String restaurantId;
  const RestaurantShell({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restaurant $restaurantId')),
      body: const Center(child: Text('Hamarosan')),
    );
  }
}
