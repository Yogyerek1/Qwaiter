import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:qwaiter_staff/features/restaurant/restaurant_provider.dart';
import '../../auth/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    if (user == null) return const SizedBox.shrink();

    return user.isOwner ? const _OwnerHome() : const _WorkerHome();
  }
}

class _OwnerHome extends StatefulWidget {
  const _OwnerHome();

  @override
  State<_OwnerHome> createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<_OwnerHome> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context
          .read<RestaurantProvider>()
          .fetchRestaurants(), // when screen loaded fetch restaurant
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Restaurants'),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(child: Text('Restaurant list - hamarosan')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _WorkerHome extends StatelessWidget {
  const _WorkerHome();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${user.username}'),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Role: ${user.role}'),
            const SizedBox(height: 8),
            Text('Restaurant: ${user.restaurantID ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
