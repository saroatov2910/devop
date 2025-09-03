import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/sign_out_user.dart';
import '../services/product_service.dart';
import '../models/products/product.dart';
import '../widgets/product_list_tile.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/ai_sheet.dart';

class HomeScreen extends StatelessWidget {
  final String userEmail;
  const HomeScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, $userEmail"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await signOutUser();
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: productService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("שגיאה בטעינת מוצרים: ${snapshot.error}"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text("אין מוצרים להצגה"));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductListTile(
                product: product,
                onTap: () async {
                  final newDate = await showDatePicker(
                    context: context,
                    initialDate: product.expirationDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (newDate != null) {
                    await productService.updateProductExpirationDate(
                      product.id,
                      newDate,
                    );
                  }
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNav(
        onItemTap: (index) {
          if (index == 3) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: const AiSheet(),
              ),
            );
          }
        },
      ),
    );
  }
}
