import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/products/product.dart';

class ProductService {
  final CollectionReference productsCollection = FirebaseFirestore.instance
      .collection('products');

  Stream<List<Product>> getProducts() {
    return productsCollection.snapshots().map((snapshot) {
      debugPrint("Docs fetched: ${snapshot.docs.length}");
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        debugPrint("Doc data: $data");

        if (data == null) {
          return Product(
            id: doc.id,
            name: 'שגיאה',
            description: 'נתונים חסרים',
            barcode: 'N/A',
            icon: Icons.error,
            expirationDate: DateTime.now(),
            checked: false,
          );
        }

        final name = data['nameProduct'] as String? ?? 'מוצר ללא שם';
        final description = data['description'] as String? ?? 'ללא תיאור';
        final barcode = data['barcode'] as String? ?? 'אין ברקוד';
        final checked = data['checked'] as bool? ?? false;

        // המרת timestamp ל-DateTime
        final expirationTimestamp = data['expirationDate'] as Timestamp?;
        final expirationDate = expirationTimestamp?.toDate() ?? DateTime.now();

        return Product(
          id: doc.id,
          name: name,
          description: description,
          barcode: barcode,
          icon: Icons.fastfood,
          checked: checked,
          expirationDate: expirationDate,
        );
      }).toList();
    });
  }

  Future<void> updateProductChecked(String productId, bool newChecked) async {
    try {
      await productsCollection.doc(productId).update({'checked': newChecked});
    } on FirebaseException catch (e) {
      debugPrint("Error updating product checked status: $e");
    }
  }

    Future <int> getProductCounter(String barcode)async{
    try{

    final docSnapshot =wait FirebaseFirestore

    }
  }
}
