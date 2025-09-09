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
      await firestore.collection('commands').add({
        'command': command,
        'device_id': 'smartfridge_pi',
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

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();

    return StreamBuilder<List<Product>>(
      stream: productService.getProducts(),
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
                      return ProductListTile(
                        product: product,
                        onTap: () async {
                          final pickedRange = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            initialDateRange: DateTimeRange(
                              start: product.expirationDate,
                              end: product.expirationDate.add(
                                const Duration(days: 7),
                              ),
                            ),
                          );
                          if (pickedRange != null) {
                            await productService.updateProductExpirationDate(
                              product.id,
                              pickedRange.end,
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
          bottomNavigationBar: BottomNav(
            isScanning: isScanning,
            onItemTap: (index) {
              if (index == 0) {
                // כפתור סריקה
                if (!isScanning) {
                  triggerPiCommand('start_scan');
                } else {
                  triggerPiCommand('stop_scan');
                }
                setState(() {
                  isScanning = !isScanning;
                });
              } else if (index == 4) {
                // Notifications tab
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
