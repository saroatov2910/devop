import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore database package
import 'package:flutter/material.dart'; // Flutter UI package
import '../models/products/product.dart'; // Product model

// Product Service: handles product data operations
class ProductService {
  // Reference to the "products" collection in Firestore
  final CollectionReference productsCollection = FirebaseFirestore.instance
      .collection('products');
  final CollectionReference historyCollection = FirebaseFirestore.instance
      .collection('products_history');

  // Returns a stream of product lists from Firestore
  Stream<List<Product>> getProducts() {
    return productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {}; // Document data
        final expirationTimestamp =
            data['expirationDate'] as Timestamp?; // Expiration date

        // Create a Product object from Firestore data
        return Product(
          id: doc.id, // Document ID
          name: data['name'] ?? 'מוצר ללא שם', // Product name
          description:
              data['description'] ?? 'ללא תיאור', // Product description
          barcode: data['barcode'] ?? 'אין ברקוד', // Product barcode
          icon: Icons.fastfood, // Default icon
          checked: data['checked'] ?? false, // Checked state
          expirationDate:
              expirationTimestamp?.toDate() ??
              DateTime.now(), // Expiration date
          category: data['category'] ?? 'לא סווג', // Product category
        );
      }).toList();
    });
  }

  // Updates the expiration date of a product in Firestore
  Future<void> updateProductExpirationDate(
    String productId, // Product ID
    DateTime newDate, // New expiration date
  ) async {
    try {
      await productsCollection.doc(productId).update({
        'expirationDate': Timestamp.fromDate(newDate), // Update field
      });
    } on FirebaseException catch (e) {
      debugPrint("Error updating expiration date: $e"); // Error handling
    }
  }

  // Counts products with a specific barcode in a list
  int countProductByBarcode(List<Product> products, String barcode) {
    return products.where((p) => p.barcode == barcode).length;
  }
}
