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
      title: Text(product.nameProduct),
      subtitle: Text(product.description),
      trailing: Checkbox(
        value: product.checked,
        onChanged: (bool? newValue) {
          if (newValue != null) {
            onTap();
          }
        },
      ),
      onTap: onTap,
    );
  }
}
