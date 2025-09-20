import 'package:flutter/material.dart';
import '../models/products/product.dart';

// Widget that displays a product in a list tile
class ProductListTile extends StatelessWidget {
  final Product product; // The product to display
  final VoidCallback onTap; // Callback when tile or checkbox is tapped
  final int count; // The number of products with the same barcode

  const ProductListTile({
    super.key,
    required this.product,
    required this.onTap,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(product.icon), // Product icon
      title: Text(product.name), // Product name
      subtitle: Text(
        "תוקף עד: ${product.expirationDate.toLocal().toString().split(' ')[0]}\nכמות: ${product.quantity}",
      ),
      trailing: Checkbox(
        value: product.checked, // Checked state
        onChanged: (_) => onTap(), // Calls onTap when checkbox changes
      ),
      onTap: onTap, // Calls onTap when tile is tapped
    );
  }
}
