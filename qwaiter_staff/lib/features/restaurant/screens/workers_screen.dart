import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qwaiter_staff/features/restaurant/worker_provider.dart';

class WorkersScreen extends StatefulWidget {
  final String restaurantId;
  const WorkersScreen({super.key, required this.restaurantId});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  Future<void> _deleteWorker(Worker w) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete worker'),
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
      await context.read<WorkerProvider>().deleteWorker(w.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkerProvider>();
    return switch (provider.status) {
      WorkerStatus.loading => const Center(child: CircularProgressIndicator()),
      WorkerStatus.error => Center(
        child: Text(provider.errorMessage ?? 'Something went wrong'),
      ),
      WorkerStatus.idle =>
        provider.workers.isEmpty
            ? const Center(child: Text('No workers yet'))
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: provider.workers.length,
                itemBuilder: (context, index) {
                  final w = provider.workers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(w.name),
                      subtitle: Text(w.role.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _showEditSheet(w),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => _deleteWorker(w),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    };
  }
}

class _WorkerFormSheet extends StatefulWidget {
  final Worker? worker;
  const _WorkerFormSheet({this.worker});

  @override
  State<_WorkerFormSheet> createState() => _WorkerFormSheetState();
}

class _WorkerFormSheetState extends State<_WorkerFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _roleController;

  @override
  void initState() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
