import 'package:flutter/material.dart';

enum MenuStatus { idle, loading, error }

class Category {
  final String id;
  final String name;
  final int displayOrder;
  final List<MenuItem> items;

  const Category({
    required this.id,
    required this.name,
    required this.displayOrder,
    required this.items,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    name: json['name'],
    displayOrder: json['displayOrder'],
    items: json['items'] ?? [],
  );
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final int price;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    price: json['price'],
  );
}
