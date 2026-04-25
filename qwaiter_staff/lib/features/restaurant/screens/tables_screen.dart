import 'package:flutter/material.dart' hide Table;
import 'package:provider/provider.dart';
import 'package:qwaiter_staff/features/restaurant/providers/table_provider.dart';
import 'package:qwaiter_staff/features/restaurant/providers/worker_provider.dart';

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

  void _showEditSheet(Table table) {
    showModalBottomSheet(
      context: context,
      builder: (_) => _TableFormSheet(table: table),
      isScrollControlled: true,
    );
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => const _TableFormSheet(),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TableProvider>();
    return Scaffold(
      body: switch (provider.status) {
        TableStatus.loading => const Center(child: CircularProgressIndicator()),
        TableStatus.error => Center(
          child: Text(provider.errorMessage ?? 'Something went wrong'),
        ),
        TableStatus.idle =>
          provider.tables.isEmpty
              ? const Center(child: Text('No tables yet'))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: provider.tables.length,
                  itemBuilder: (context, index) {
                    final t = provider.tables[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(t.tableName),
                        subtitle: Text(t.authCode),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => _showEditSheet(t),
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () => _deleteWorker(t),
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

class _TableFormSheet extends StatefulWidget {
  final Table? table;
  const _TableFormSheet({this.table});

  @override
  State<_TableFormSheet> createState() => _TableFormSheetState();
}

class _TableFormSheetState extends State<_TableFormSheet> {
  late final TextEditingController _tableNameController;
  late final TextEditingController _authCodeController;

  @override
  void initState() {
    super.initState();
    _tableNameController = TextEditingController(text: widget.table?.tableName);
    _authCodeController = TextEditingController(text: widget.table?.authCode);
  }

  @override
  void dispose() {
    _tableNameController.dispose();
    _authCodeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final tableName = _tableNameController.text.trim();
    final authCode = _authCodeController.text.trim();
    final provider = context.read<TableProvider>();

    if (tableName.isEmpty || authCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Table name and auth code are required!')),
      );
      return;
    }

    bool success = false;

    if (widget.table == null) {
      // Create
      if (authCode.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Auth code is required for new table!')),
        );
        return;
      }

      success = await provider.createTable(
        provider.restaurantID,
        tableName,
        authCode,
      );
    } else {
      success = await provider.updateTable(
        provider.restaurantID,
        widget.table!.tableID,
        tableName,
        authCode,
      );
    }

    if (success && mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.table == null
                ? 'Table successfully created!'
                : 'Table successfully updated!',
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
        context.watch<TableProvider>().status == TableStatus.loading;
    final isEdit = widget.table != null;

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
            isEdit ? 'Edit table' : 'New table',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _tableNameController,
            decoration: const InputDecoration(labelText: 'Table name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _authCodeController,
            decoration: const InputDecoration(labelText: 'Auth code'),
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
