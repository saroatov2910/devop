# Function Overview

This document summarizes the main functions in the **devop** Flutter project, organized by file.

---

## lib/models/products/product.dart

- **Product(...)**  
  Constructor for the Product model.

---

## lib/services/product_service.dart

- **Stream<List<Product>> getProducts(BuildContext context)**  
  Returns a stream of products from Firestore.

- **Future<void> updateProductExpirationDate(String productId, DateTime newDate)**  
  Updates the expiration date of a product.

- **int countProductByBarcode(List<Product> products, String barcode)**  
  Counts products by barcode.

- **Future<int?> getQuantityByBarcode(String barcode)**  
  Gets the quantity of a product by barcode.

- **Future<void> moveAndDeleteExpiredProducts()**  
  Moves expired products to history and deletes them from the main collection.

---

## lib/services/user_service.dart

- **Future<void> registerUser(...)**  
  Registers a new user.

- **Future<void> signInUser(...)**  
  Signs in a user.

- **Future<void> signOutUser()**  
  Signs out the current user.

---

## lib/services/notification_service.dart

- **static List<Notification> getExpiringProductNotifications(List<Product> products)**  
  Returns notifications for products that are about to expire.

---

## lib/screens/home_screen.dart

- **void triggerPiCommand(String command)**  
  Sends a command to the Pi via Firestore.

- **void editProductName(BuildContext context, Product product)**  
  Opens a dialog to edit a product's name and expiration date.

- **Future<void> addProduct(Product product)**  
  Adds a new product to Firestore and plays a sound.

- **Widget build(BuildContext context)**  
  Builds the main home screen UI.

---

## lib/widgets/add_product_dialog.dart

- **AddProductDialog({required Function(Product) onAdd})**  
  Dialog widget for adding a new product manually.

---

## lib/widgets/product_list_tile.dart

- **ProductListTile({required Product product, required Function onTap, required int count})**  
  Widget for displaying a product in the list.

---

## lib/widgets/bottom_nav.dart

- **BottomNav({required bool isScanning, required Function(int) onItemTap})**  
  Bottom navigation bar widget.

---

## lib/widgets/ai_sheet.dart

- **AiSheet({required List<Product> products})**  
  Widget for displaying AI suggestions.

---

## lib/utils/utils.dart

- **(Various utility/helper functions as needed)**

---

## lib/screens/login_screen.dart, register_screen.dart, auth_screen.dart, profile_scree.dart

- **Functions for user authentication, registration, and profile management.**

---

## lib/screens/products_list_screen.dart

- **Functions for displaying and managing the list of products.**

---

## lib/screens/ai_sheet.dart

- **Functions for interacting with AI features and displaying suggestions.**

---

## Notes

- For full details, see the source code in each file.
- This overview covers the main public functions and constructors.