import 'package:flutter/material.dart' hide Table;
import 'package:provider/provider.dart';
import 'package:qwaiter_staff/features/restaurant/table_provider.dart';

class TablesScreen extends StatefulWidget {
  final String restaurantId;
  const TablesScreen({super.key, required this.restaurantId});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TableProvider>();
      provider.setRestaurantID(widget.restaurantId);
      provider.fetchTables();
    });
  }

  Future<void> _deleteWorker(Table t) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete table'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<TableProvider>().deleteTable(
        t.restaurantID,
        t.tableID,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Tables - hamarosan'));
  }
}
