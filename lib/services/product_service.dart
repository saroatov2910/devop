// lib/services/product_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:devop/models/products/product.dart';

class ProductService {
  final CollectionReference productsCollection = FirebaseFirestore.instance
      .collection('products');

  Stream<List<Product>> getProducts() {
    return productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;

        if (data == null) {
          return Product(
            id: doc.id,
            nameProduct: 'שגיאה',
            description: 'נתונים חסרים',
            icon: Icons.error, // Use a default icon
            checked: false,
          );
        }

        final nameProduct = data['nameProduct'] as String? ?? 'מוצר ללא שם';
        final description = data['description'] as String? ?? 'ללא תיאור';
        final checked = data['checked'] as bool? ?? false;

        // Use a default icon instead of trying to pull 'icon_name'
        return Product(
          id: doc.id,
          nameProduct: nameProduct,
          description: description,
          icon: Icons.fastfood, // You can use any default icon you like
          checked: checked,
        );
      }).toList();
    });
  }

  // You can now remove the getIconDataByName function since it is no longer used.

  Future<void> updateProductChecked(String productId, bool newChecked) async {
    try {
      await productsCollection.doc(productId).update({'checked': newChecked});
    } on FirebaseException catch (e) {
      debugPrint("Error updating product checked status: $e");
    }
  }
}
