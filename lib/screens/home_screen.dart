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
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail;
  const HomeScreen({super.key, required this.userEmail});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isScanning = false;

  // Sends a command to the Pi via Firestore
  void triggerPiCommand(String command) async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('scanner_commands').doc('control').set({
        'command': command,
        'timestamp': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Command "$command" sent to Pi!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error sending command: $e')));
      }
    }
  }

  // Opens a dialog to manually edit the product name
  void editProductName(BuildContext context, Product product) {
    final controller = TextEditingController(text: product.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Product Name'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'New Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('My_Fridge')
                  .doc(product.id)
                  .update({'name': controller.text});
              Navigator.pop(context);
              setState(() {}); // Refresh the screen
            },
            child: Text('Save'),
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
            body: Center(
              child: Text("Error loading products: ${snapshot.error}"),
            ),
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
              ? const Center(child: Text("No products to display"))
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
                        onTap: () async {
                          // Play a short beep sound when product is tapped/scanned
                          final player = AudioPlayer();
                          await player.play(AssetSource('beep.mp3'));

                          // Open dialog to edit product name
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
                // Start or stop scanning
                if (!isScanning) {
                  triggerPiCommand('start');
                } else {
                  triggerPiCommand('stop');
                }
                setState(() {
                  isScanning = !isScanning;
                });
              } else if (index == 4) {
                // Show notifications for expiring products
                final notifications =
                    NotificationService.getExpiringProductNotifications(
                      products,
                    );
                showModalBottomSheet(
                  context: context,
                  builder: (context) => ListView(
                    children: notifications.isEmpty
                        ? [const ListTile(title: Text('No notifications'))]
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
                // Show AI sheet
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
