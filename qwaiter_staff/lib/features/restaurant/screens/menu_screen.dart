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

  Future<void> _deleteMenuItem(MenuItem m) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete menu item'),
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
      await context.read<MenuProvider>().deleteMenuItem(m.id);
    }
  }

  void _showEditSheetForCategory(Category category) {
    showModalBottomSheet(
      context: context,
      builder: (_) => _CategoryFormSheet(category: category),
      isScrollControlled: true,
    );
  }

  void _showCreateSheetForCategory() {
    showModalBottomSheet(
      context: context,
      builder: (_) => _CategoryFormSheet(),
      isScrollControlled: true,
    );
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
                            onPressed: () => _showEditSheetForCategory(c),
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
                                  onPressed: () => _deleteMenuItem(item),
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
        onPressed: () => _showCreateSheetForCategory(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CategoryFormSheet extends StatefulWidget {
  final Category? category;
  const _CategoryFormSheet({this.category});

  @override
  State<_CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends State<_CategoryFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _displayOrderController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
    _displayOrderController = TextEditingController(
      text: widget.category?.displayOrder.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _displayOrderController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final displayOrder = _displayOrderController.text.trim();
    final provider = context.read<MenuProvider>();

    if (name.isEmpty || displayOrder.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category name and display order are required!'),
        ),
      );
      return;
    }

    bool success = false;

    if (widget.category == null) {
      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category name is required for new category!'),
          ),
        );
        return;
      }
    }

    if (widget.category == null) {
      if (displayOrder.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Display order is required for new category!'),
          ),
        );
        return;
      }

      success = await provider.createCategory(name, int.parse(displayOrder));
    } else {
      success = await provider.updateCategory(
        widget.category!.id,
        name,
        int.parse(displayOrder),
      );
    }

    if (success && mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.category == null
                ? 'Category successfully created!'
                : 'Category successfully updated!',
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
    // TODO: implement build
    throw UnimplementedError();
  }
}
