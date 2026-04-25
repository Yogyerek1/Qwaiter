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
  late final TextEditingController _restaurantNameController;
  late final TextEditingController _restaurantAddressController;

  @override
  void initState() {
    super.initState();
    final restaurant = context
        .read<RestaurantProvider>()
        .restaurants
        .firstWhere((r) => r.id == widget.restaurantId);
    _restaurantNameController = TextEditingController(text: restaurant.name);
    _restaurantAddressController = TextEditingController(
      text: restaurant.address,
    );
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _restaurantAddressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _restaurantNameController.text.trim();
    final address = _restaurantAddressController.text.trim();
    final provider = context.read<RestaurantProvider>();

    final success = await provider.updateRestaurant(
      widget.restaurantId,
      name.isEmpty ? null : name,
      address.isEmpty ? null : address,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Restaurant updated!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantProvider>();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Restaurant name',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
