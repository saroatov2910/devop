import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/products/product.dart';

class ProductService {
  final CollectionReference productsCollection = FirebaseFirestore.instance
      .collection('products');

  Stream<List<Product>> getProducts() {
    return productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        final expirationTimestamp = data['expirationDate'] as Timestamp?;
        return Product(
          id: doc.id,
          name: data['name'] ?? 'מוצר ללא שם',
          description: data['description'] ?? 'ללא תיאור',
          barcode: data['barcode'] ?? 'אין ברקוד',
          icon: Icons.fastfood,
          checked: data['checked'] ?? false,
          expirationDate: expirationTimestamp?.toDate() ?? DateTime.now(),
          category: data['category'] ?? 'לא סווג',
        );
      }).toList();
    });
  }

  Future<void> updateProductChecked(String productId, bool newChecked) async {
    try {
      await productsCollection.doc(productId).update({'checked': newChecked});
    } on FirebaseException catch (e) {
      debugPrint("Error updating product: $e");
    }
  }

  int countProductByBarcode(List<Product> products, String barcode) {
    return products.where((p) => p.barcode == barcode).length;
  }
}
