// lib/widgets/product_list_tile.dart
import 'package:flutter/material.dart';
import '../models/products/product.dart';

class ProductListTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductListTile({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(product.icon),
      title: Text(product.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.description),
          Text("ID: ${product.id}"),
          Text("Barcode: ${product.barcode}"), // barcode
          Text(
            "Expires:${product.expirationDate.toLocal().toString().split(' ')[0]}",
          ),
        ],
      ),
      trailing: Checkbox(
        value: product.checked,
        onChanged: (bool? value) {
          onTap();
        },
      ),
      onTap: onTap,
    );
  }
}
