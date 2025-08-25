import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devop/models/products/product.dart';
import '../services/product_service.dart';

class ProductService {
  Stream<List<Product>> getProducts() {
    return productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product(
          id: doc.id,
          nameProduct: doc['nameProduct'],
          description: doc['description'],
        );
      }).toList();
    });
  }
}
