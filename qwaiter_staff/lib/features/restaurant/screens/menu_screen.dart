import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qwaiter_staff/features/restaurant/menu_provider.dart';

class MenuScreen extends StatefulWidget {
  final String restaurantId;
  const MenuScreen({super.key, required this.restaurantId});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MenuProvider>();
      provider.setRestaurantID(widget.restaurantId);
      provider.fetchMenu();
    });
  }

  Future<void> _deleteCategory(Category c) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete category'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<MenuProvider>().deleteCategory(c.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MenuProvider>();
    return Scaffold(
      body: switch (provider.status) {
        MenuStatus.loading => const Center(child: CircularProgressIndicator()),
        MenuStatus.error => Center(
          child: Text(provider.errorMessage ?? 'Something went wrong'),
        ),
        MenuStatus.idle =>
          provider.categories.isEmpty
              ? const Center(child: Text('No tables yet'))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: provider.categories.length,
                  itemBuilder: (context, index) {
                    final c = provider.categories[index];
                    return ExpansionTile(
                      title: Text(c.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => {}, // TODO: EDIT CATEGORY
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteCategory(c),
                          ),
                        ],
                      ),
                      children: c.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: ListTile(
                            title: Text(item.name),
                            subtitle: Text('${item.price} Ft'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => {}, // TODO: EDIT ITEM
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => {}, // TODO: DELETE ITEM
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
      ), // TODO: ADD CATEGORY
    );
  }
}
