# Smart Fridge Manager

A cross-platform Flutter app for managing fridge inventory, tracking product expiration, and automating product entry using AI and Raspberry Pi 5 with camera integration.

---

## Features

- Real-time product tracking with Firebase
- Manual and automated (camera/barcode) product entry
- Expiration notifications
- AI-powered suggestions for food management
- Integration with Raspberry Pi 5 and camera

---

## Folder Structure

See [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for a detailed breakdown.

---

## Main Functions

See [Function.md](Function.md) for a full list of main functions and their descriptions.

**Examples of key functions:**

- `Stream<List<Product>> getProducts(BuildContext context)`  
  Returns a stream of products from Firestore.

- `Future<void> addProduct(Product product)`  
  Adds a new product to Firestore and plays a sound.

- `void triggerPiCommand(String command)`  
  Sends a command to the Raspberry Pi via Firestore.

- `void editProductName(BuildContext context, Product product)`  
  Opens a dialog to edit a product's name and expiration date.

- `Future<void> moveAndDeleteExpiredProducts()`  
  Moves expired products to history and deletes them from the main collection.

- `static List<Notification> getExpiringProductNotifications(List<Product> products)`  
  Returns notifications for products that are about to expire.

---

## Installation

```bash
git clone <repo-url>
cd devop
flutter pub get