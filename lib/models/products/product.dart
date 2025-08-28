// lib/models/products/product.dart
// this class represents a product in the app
// it contains properties like id, nameProduct, description, etc.

import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String barcode;
  final IconData icon;
  final DateTime expirationDate;

  bool checked;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.barcode,
    required this.icon,
    required this.expirationDate,
    this.checked = false,
  });

  Color getExpirationColor() {}
}
