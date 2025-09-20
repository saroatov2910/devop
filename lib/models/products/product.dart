import 'package:flutter/material.dart';

// Model for a product item
class Product {
  final String id; // Unique product ID
  final String name; // Product name
  final String description; // Product description
  final String barcode; // Product barcode
  final IconData icon; // Icon representing the product
  final DateTime expirationDate; // Expiration date of the product
  final bool checked; // Whether the product is checked/selected
  final String category; // Product category
  final int quantity; // Product quantity

  // Product class constructor
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.barcode,
    required this.icon,
    required this.expirationDate,
    required this.category,
    this.checked = false, // Default value for checked is false
    required this.quantity,
  });

  // Returns a color based on the expiration date:
  // - Red if expired
  // - Yellow if expiring within 3 days
  // - Green if fresh
  Color getExpirationColor() {
    final now = DateTime.now();
    if (expirationDate.isBefore(now)) return Colors.red;
    if (expirationDate.difference(now).inDays <= 3) return Colors.yellow;
    return Colors.green;
  }
}
