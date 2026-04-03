import 'package:flutter/material.dart';

class TablesScreen extends StatefulWidget {
  final String restaurantId;
  const TablesScreen({super.key, required this.restaurantId});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Tables - hamarosan'));
  }
}
