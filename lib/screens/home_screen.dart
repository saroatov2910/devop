import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/sign_out_user.dart';
import '../services/product_service.dart';
import '../services/notification_service.dart';
import '../models/products/product.dart';
import '../widgets/product_list_tile.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/ai_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail;
  const HomeScreen({super.key, required this.userEmail});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isScanning = false;

  void triggerPiCommand(String command) async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('scanner_commands').doc('control').set({
        'command': command,
        'timestamp': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('פעולה "$command" נשלחה ל-Pi!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('שגיאה בשליחת הפעולה: $e')));
      }
    }
  }

  // פונקציה לעריכת שם מוצר
  void editProductName(BuildContext context, Product product) {
    final controller = TextEditingController(text: product.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ערוך שם מוצר'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'שם חדש'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ביטול'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('My_Fridge')
                  .doc(product.id)
                  .update({'name': controller.text});
              Navigator.pop(context);
              setState(() {}); // רענון המסך
            },
            child: Text('שמור'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();

    return StreamBuilder<List<Product>>(
      stream: productService.getProducts(context),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Welcome, ${widget.userEmail}"),
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
            title: Text("Welcome, ${widget.userEmail}"),
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
              : RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final count = productService.countProductByBarcode(
                        products,
                        product.barcode,
                      );
                      return ProductListTile(
                        product: product,
                        onTap: () {
                          editProductName(context, product);
                        },
                        count: count,
                      );
                    },
                  ),
                ),
          bottomNavigationBar: BottomNav(
            isScanning: isScanning,
            onItemTap: (index) {
              if (index == 0) {
                if (!isScanning) {
                  triggerPiCommand('start');
                } else {
                  triggerPiCommand('stop');
                }
                setState(() {
                  isScanning = !isScanning;
                });
              } else if (index == 4) {
                final notifications =
                    NotificationService.getExpiringProductNotifications(
                      products,
                    );
                showModalBottomSheet(
                  context: context,
                  builder: (context) => ListView(
                    children: notifications.isEmpty
                        ? [const ListTile(title: Text('אין התראות כרגע'))]
                        : notifications
                              .map(
                                (n) => ListTile(
                                  title: Text(n.title),
                                  subtitle: Text(n.body),
                                ),
                              )
                              .toList(),
                  ),
                );
              } else if (index == 3) {
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
