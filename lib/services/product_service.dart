import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/products/product.dart';

class ProductService {
  // Reference to the main products collection (now 'My_Fridge')
  final CollectionReference productsCollection = FirebaseFirestore.instance
      .collection('My_Fridge');
  // Reference to the history collection for expired products
  final CollectionReference historyCollection = FirebaseFirestore.instance
      .collection('products_history');

  /// Returns a stream of products from Firestore in realtime.
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

        // Use product_name if name is missing
        debugPrint(
          'Product: ${data['product_name'] ?? data['name']}, expirationDate: $expirationDate',
        );

        return Product(
          id: doc.id,
          name: data['name'] ?? data['product_name'] ?? 'מוצר ללא שם',
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

  /// Updates the expiration date of a product in Firestore.
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

  /// Counts products by barcode in a given list.
  int countProductByBarcode(List<Product> products, String barcode) {
    return products.where((p) => p.barcode == barcode).length;
  }

  /// Moves expired products to history and deletes them from the main collection.
  Future<void> moveAndDeleteExpiredProducts() async {
    final now = DateTime.now();
    final snapshot = await productsCollection.get();
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final expirationField = data['expirationDate'];
      Timestamp? expirationDate;
      if (expirationField is Timestamp) {
        expirationDate = expirationField;
      }
      if (expirationDate != null && expirationDate.toDate().isBefore(now)) {
        await historyCollection.doc(doc.id).set(data);
        await productsCollection.doc(doc.id).delete();
      }
    }
  }
}
