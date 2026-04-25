import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qwaiter_staff/features/restaurant/providers/restaurant_provider.dart';

class SettingsScreen extends StatefulWidget {
  final String restaurantId;
  const SettingsScreen({super.key, required this.restaurantId});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantProvider>();
    final restaurant = provider.restaurants.firstWhere(
      (r) => r.id == widget.restaurantId,
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${restaurant.name}'),
            Text('Address: ${restaurant.address}'),
          ],
        ),
      ),
    );
  }
}
