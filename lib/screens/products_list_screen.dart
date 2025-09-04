import 'package:flutter/material.dart';
import '../models/products/product.dart';

// Product ListTile widget displays product information in a list
class ProductListTile extends StatelessWidget {
  // The product to display
  final Product product;
  // Callback when the tile or checkbox is tapped
  final VoidCallback onTap;

  // Constructor requires product and onTap callback
  const ProductListTile({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        product.icon, // Product icon
        color: product.getExpirationColor(), // Color based on expiration
      ),
      title: Text(product.name), // Product name
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.description), // Product description
          Text("ID: ${product.id}"), // Product ID
          Text("Barcode: ${product.barcode}"), // Product barcode
          Text(
            // Expiration date formatted as YYYY-MM-DD
            "Expires: ${product.expirationDate.toLocal().toString().split(' ')[0]}",
          ),
        ],
      ),
      trailing: Checkbox(
        value: product.checked, // Checked state
        onChanged: (_) => onTap(), // Calls onTap when changed
      ),
      onTap: onTap, // Calls onTap when tile is tapped
    );
  }
}
