import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/products/product.dart';

class ProductService {
  final CollectionReference productsCollection = FirebaseFirestore.instance
      .collection('My_Fridge');
  final CollectionReference historyCollection = FirebaseFirestore.instance
      .collection('products_history');

  Stream<List<Product>> getProducts(BuildContext context) {
    return productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        final productName =
            data['name'] ?? data['product_name'] ?? 'מוצר ללא שם';

        if (productName == 'מוצר ללא שם') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Warning: Product name is missing!'),
              ),
            );
          });
        }

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

        debugPrint('Product: $productName, expirationDate: $expirationDate');

        return Product(
          id: doc.id,
          name: productName,
          description: data['description'] ?? 'ללא תיאור',
          barcode: data['barcode'] ?? 'אין ברקוד',
          icon: Icons.fastfood,
          checked: data['checked'] ?? false,
          expirationDate: expirationDate,
          category: data['category'] ?? 'לא סווג',
          quantity: data['quantity'] ?? 1,
        );
      }).toList();
    });
  }

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

  /// Get quantity of a product by barcode from Firestore
  Future<int?> getQuantityByBarcode(String barcode) async {
    final snapshot = await productsCollection
        .where('barcode', isEqualTo: barcode)
        .limit(1)
        .get();
    int sum = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      sum += (data['quantity'] ?? 1) as int;
    }
    return sum;
  }

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
