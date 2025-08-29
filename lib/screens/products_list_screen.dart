// lib/screens/products_list_screen.dart
import 'package:flutter/material.dart';
import 'package:devop/models/products/product.dart';
import 'package:devop/services/product_service.dart';

class ProductsListScreen extends StatelessWidget {
  const ProductsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductService productService = ProductService();

    return Scaffold(
      appBar: AppBar(title: const Text('רשימת מוצרים')),
      body: StreamBuilder<List<Product>>(
        stream: productService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('שגיאה: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('אין מוצרים זמינים.'));
          }

          final products = snapshot.data!;
          debugPrint("${products.length} products");
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.description),
                leading: Icon(product.icon),
                trailing: Checkbox(
                  value: product.checked,
                  onChanged: (bool? newValue) {
                    productService.updateProductChecked(product.id, newValue!);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
