# PROJECT_STRUCTURE.md

This document describes the structure and main components of the **devop** Flutter project.

---

## Folder Structure

```
lib/
├── firebase_options.dart         # Firebase configuration
├── main.dart                    # App entry point
├── pi.py                        # Python script for Raspberry Pi integration
│
├── models/                      # Data models
│   ├── new_user.dart
│   ├── registered_user.dart
│   ├── Notification/
│   │   └── notification.dart
│   └── products/
│       └── product.dart
│
├── pi/                          # Additional Raspberry Pi code
│   └── new_presentation_code.py
│
├── screens/                     # UI screens
│   ├── ai_sheet.dart
│   ├── auth_screen.dart
│   ├── Brochure.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── products_list_screen.dart
│   ├── profile_scree.dart
│   ├── register_screen.dart
│   ├── smart_fridge_home.dart
│   └── video.dart
│
├── services/                    # Business logic and data access
│   ├── ai_service.dart
│   ├── notification_service.dart
│   ├── product_service.dart
│   ├── register_user.dart
│   ├── sign_in_user.dart
│   ├── sign_out_user.dart
│   └── user_service.dart
│
├── utils/                       # Utility functions
│   └── utils.dart
│
└── widgets/                     # Reusable UI components
    ├── add_product_dialog.dart
    ├── ai_sheet.dart
    ├── bottom_nav.dart
    └── product_list_tile.dart
```

---

## Hardware Integration

**New:**  
- Added support for **Raspberry Pi 5 with camera**.
- Python scripts (`pi.py`, `pi/new_presentation_code.py`) are used for hardware integration, such as camera control and communication with the Flutter app.

---

## Main Components

### 1. **Models (`lib/models/`)**
- **products/product.dart**: Defines the `Product` model.
- **Notification/notification.dart**: Notification model.
- **new_user.dart, registered_user.dart**: User models.

### 2. **Services (`lib/services/`)**
- **product_service.dart**: Handles CRUD operations for products in Firestore.
- **notification_service.dart**: Manages notifications for expiring products.
- **ai_service.dart**: Integrates with AI features.
- **user_service.dart, register_user.dart, sign_in_user.dart, sign_out_user.dart**: User authentication and management.

### 3. **Screens (`lib/screens/`)**
- **home_screen.dart**: Main screen showing the product list.
- **login_screen.dart, register_screen.dart, auth_screen.dart**: Authentication screens.
- **products_list_screen.dart**: Displays all products.
- **profile_scree.dart**: User profile screen.
- **ai_sheet.dart, smart_fridge_home.dart, Brochure.dart, video.dart**: Additional features and UI screens.

### 4. **Widgets (`lib/widgets/`)**
- **add_product_dialog.dart**: Dialog for adding a product manually.
- **product_list_tile.dart**: Widget for displaying a product in the list.
- **bottom_nav.dart**: Bottom navigation bar.
- **ai_sheet.dart**: Widget for AI suggestions.

### 5. **Utils (`lib/utils/`)**
- **utils.dart**: Utility/helper functions.

### 6. **Other**
- **firebase_options.dart**: Firebase configuration (auto-generated).
- **main.dart**: Application entry point.
- **pi.py, pi/new_presentation_code.py**: Python scripts for Raspberry Pi 5 with camera integration.

---

## How to Extend

- Add new models to `lib/models/`
- Add new services to `lib/services/`
- Add new screens to `lib/screens/`
- Add reusable widgets to `lib/widgets/`
- Place utility functions in `lib/utils/`

---

## Build & Run

```bash
flutter pub get
flutter run
flutter build apk
flutter build web
```

---

## Notes

- For more details, see the documentation in each file and folder.
- Python scripts are used for hardware integration with Raspberry Pi 5 and camera.
- The project is modular and easy to extend.