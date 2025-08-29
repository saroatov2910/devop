import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String barcode;
  final IconData icon;
  final DateTime expirationDate;
  final bool checked;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.barcode,
    required this.icon,
    required this.expirationDate,
    required this.category,
    this.checked = false,
  });

  Color getExpirationColor() {
    final now = DateTime.now();
    if (expirationDate.isBefore(now)) return Colors.red;
    if (expirationDate.difference(now).inDays <= 3) return Colors.yellow;
    return Colors.green;
  }
}
