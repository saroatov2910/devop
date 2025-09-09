import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/products/product.dart';

class ProductService {
  final CollectionReference productsCollection = FirebaseFirestore.instance
      .collection('My_Fridge');
  final CollectionReference historyCollection = FirebaseFirestore.instance
      .collection('products_history');

  // Stream of products from Firestore (Realtime)
  Stream<List<Product>> getProducts() {
    return productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};

        // Handle expirationDate as Timestamp or String
        final expirationRaw = data['expirationDate'];
        DateTime expirationDate;
        if (expirationRaw is Timestamp) {
          expirationDate = expirationRaw.toDate();
        } else if (expirationRaw is String) {
          try {
            expirationDate = DateTime.parse(expirationRaw);
          } catch (_) {
            expirationDate = DateTime.now();
          }
        } else {
          expirationDate = DateTime.now();
        }

        debugPrint('Product: ${data['name']}, expirationDate: $expirationDate');

        return Product(
          id: doc.id,
          name: data['name'] ?? 'מוצר ללא שם',
          description: data['description'] ?? 'ללא תיאור',
          barcode: data['barcode'] ?? 'אין ברקוד',
          icon: Icons.fastfood,
          checked: data['checked'] ?? false,
          expirationDate: expirationDate,
          category: data['category'] ?? 'לא סווג',
        );
      }).toList();
    });
  }

  // Update product expiration date in Firestore
  Future<void> updateProductExpirationDate(
    String productId,
    DateTime newDate,
  ) async {
    try {
      await productsCollection.doc(productId).update({
        'expirationDate': Timestamp.fromDate(newDate),
      });
    } on FirebaseException catch (e) {
      debugPrint("Error updating expiration date: $e");
    }
  }

  // Count products by barcode
  int countProductByBarcode(List<Product> products, String barcode) {
    return products.where((p) => p.barcode == barcode).length;
  }

  // Move expired products to history and delete from main collection
  Future<void> moveAndDeleteExpiredProducts() async {
    final now = DateTime.now();
    final snapshot = await productsCollection.get();
    for (var doc in snapshot.docs) {
      final expirationDate =
          (doc.data() as Map<String, dynamic>).containsKey('expirationDate') &&
              (doc.data() as Map<String, dynamic>)['expirationDate']
                  is Timestamp
          ? (doc.data() as Map<String, dynamic>)['expirationDate'] as Timestamp
          : null;
      if (expirationDate != null && expirationDate.toDate().isBefore(now)) {
        await historyCollection.doc(doc.id).set(doc.data());
        await productsCollection.doc(doc.id).delete();
      }
    }
  }
}
