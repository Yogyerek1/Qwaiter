import 'package:flutter/material.dart';

class WorkersScreen extends StatefulWidget {
  final String restaurantId;
  const WorkersScreen({super.key, required this.restaurantId});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Workers - hamarosan'));
  }
}
