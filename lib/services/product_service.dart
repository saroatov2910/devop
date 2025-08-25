import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devop/models/products/product.dart';

class ProductService {
  // Fix: The productsCollection variable is now defined and initialized here.
  final CollectionReference productsCollection = FirebaseFirestore.instance
      .collection('products');

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

  //The updateProduct function partially updates a document in Firebase by changing
  // the description field of a specific product without deleting its other data.
  Future<void> updateProduct(String productId, String newDescription) async {
    try {
      await productsCollection.doc(productId).update({
        'description': newDescription,
      });
      print('Product updated successfully!');
    } catch (e) {
      print('Error updating product: $e');
    }
  }
}
