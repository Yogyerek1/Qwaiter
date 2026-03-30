import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qwaiter_staff/features/restaurant/worker_provider.dart';
import 'package:qwaiter_staff/shared/enums/worker_role.dart';

class WorkersScreen extends StatefulWidget {
  final String restaurantId;
  const WorkersScreen({super.key, required this.restaurantId});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<WorkerProvider>();
      provider.setRestaurantID(widget.restaurantId);
      provider.fetchWorkers();
    });
  }

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

  void _showEditSheet(Worker worker) {
    showModalBottomSheet(
      context: context,
      builder: (_) => _WorkerFormSheet(worker: worker),
      isScrollControlled: true,
    );
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => const _WorkerFormSheet(),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkerProvider>();
    return Scaffold(
      body: switch (provider.status) {
        WorkerStatus.loading => const Center(
          child: CircularProgressIndicator(),
        ),
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
                        subtitle: Text(w.role.name),
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
      },
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateSheet,
        child: const Icon(Icons.add),
      ),
    );
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
  WorkerRole? _selectedRole;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.worker?.name);
    _usernameController = TextEditingController(text: widget.worker?.username);
    _passwordController = TextEditingController(text: '');

    _selectedRole = widget.worker?.role;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final provider = context.read<WorkerProvider>();

    if (name.isEmpty || username.isEmpty || _selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name, username and role are required!')),
      );
      return;
    }

    bool success = false;

    if (widget.worker == null) {
      // Create
      if (password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password is required for new worker!')),
        );
        return;
      }

      success = await provider.createWorker(
        name,
        username,
        password,
        _selectedRole!,
      );
    } else {
      // Update
      final passwordToSend = password.isNotEmpty ? password : null;

      success = await provider.updateWorker(
        widget.worker!.id,
        name,
        username,
        passwordToSend,
        _selectedRole,
      );
    }

    if (success && mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.worker == null
                ? 'Worker successfully created!'
                : 'Worker successfully updated!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Something went wrong!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.watch<WorkerProvider>().status == WorkerStatus.loading;
    final isEdit = widget.worker != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEdit ? 'Edit worker' : 'New worker',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              helperText: 'Leave empty to keep current password',
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<WorkerRole>(
            value: _selectedRole,
            decoration: const InputDecoration(labelText: 'Role'),
            items: WorkerRole.values.map((role) {
              return DropdownMenuItem(child: Text(role.name), value: role);
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedRole = value;
              });
            },
            validator: (value) =>
                value == null ? 'Role must be selected' : null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : _submit,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text(isEdit ? 'Save' : 'Create'),
            ),
          ),
        ],
      ),
    );
  }
}
