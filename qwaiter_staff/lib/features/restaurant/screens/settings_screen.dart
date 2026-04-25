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
    _restaurantNameController = TextEditingController();
    _restaurantAddressController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final restaurants = context.read<RestaurantProvider>().restaurants;
      final restaurant = restaurants.firstWhere(
        (r) => r.id == widget.restaurantId,
        orElse: () => throw Exception('Restaurant not found'),
      );
      _restaurantNameController.text = restaurant.name;
      _restaurantAddressController.text = restaurant.address;
    });
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
    final isLoading =
        context.watch<RestaurantProvider>().status == RestaurantStatus.loading;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _restaurantNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _restaurantAddressController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Address',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
