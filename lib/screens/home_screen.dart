import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/sign_out_user.dart';
import '../services/product_service.dart';
import '../models/products/product.dart';
import '../widgets/product_list_tile.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/ai_sheet.dart';

// Home Screen:
class HomeScreen extends StatelessWidget {
  final String userEmail;
  const HomeScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();

    return StreamBuilder<List<Product>>(
      stream: productService.getProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
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
            body: Center(child: Text("שגיאה בטעינת מוצרים: ${snapshot.error}")),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final products = snapshot.data ?? [];
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
          body: products.isEmpty
              ? const Center(child: Text("אין מוצרים להצגה"))
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductListTile(
                      product: product,
                      onTap: () async {
                        // Opens date range picker, prevents selecting past dates
                        final pickedRange = await showDateRangePicker(
                          context: context,
                          firstDate:
                              DateTime.now(), // Prevents selecting dates before today
                          lastDate: DateTime(2100),
                          initialDateRange: DateTimeRange(
                            start: product.expirationDate,
                            end: product.expirationDate.add(
                              const Duration(days: 7),
                            ),
                          ),
                        );
                        // If a new range is selected, update the expiration date in Firebase
                        if (pickedRange != null) {
                          await productService.updateProductExpirationDate(
                            product.id,
                            pickedRange.end, // Save the end date as expiration
                          );
                        }
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
                    child: AiSheet(products: products),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
