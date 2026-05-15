# BdApps Bazaar 🛍️

A modern, premium single-screen e-commerce product list Flutter app — built for a university assignment.

---

## ✨ Features

| Feature                | Details                                         |
|------------------------|-------------------------------------------------|
| **Product List**       | 2-column responsive grid with animated cards    |
| **Add Product**        | Bottom sheet form with name + price validation  |
| **Search**             | Instant live search by product name             |
| **Sort**               | Name A→Z / Z→A, Price Low→High / High→Low       |
| **Map Data Structure** | `List<Map<String, dynamic>>` throughout         |
| **Snackbar**           | Confirmation on product add                     |
| **Empty State**        | Beautiful illustration for empty / no-results   |
| **Animations**         | Staggered card entrance, FAB scale, sheet slide |

---

## 🗂️ Folder Structure

```
bdapps_bazaar/
├── lib/
│   ├── main.dart               ← App entry point + MaterialApp + theme
│   ├── home_screen.dart        ← Main single screen (StatefulWidget)
│   ├── product_data.dart       ← Sample data & icon/colour helpers
│   └── widgets/
│       ├── product_card.dart   ← Individual product card widget
│       ├── add_product_sheet.dart ← Bottom sheet form for adding products
│       ├── sort_menu.dart      ← Popup sort menu + SortMode constants
│       └── empty_state.dart    ← Empty / no-results illustration
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## 🚀 How to Run

### Prerequisites
- Flutter SDK ≥ 3.0 installed → [flutter.dev/get-started](https://flutter.dev/get-started)
- An emulator or physical device connected

### Steps

```bash
# 1. Navigate into the project folder
cd bdapps_bazaar

# 2. Get dependencies
flutter pub get

# 3. Run the app
flutter run
```

For a specific device:
```bash
flutter devices                  # list available devices
flutter run -d <device_id>       # run on chosen device
```

---

## 🎨 Design Highlights

- **Material 3** with purple/indigo gradient theme
- Gradient `SliverAppBar` that collapses on scroll
- 2-column responsive grid with per-card accent colours
- Staggered fade+slide entrance animations
- Floating Action Button with press-scale micro-interaction
- Animated bottom sheet for adding products
- South-Asian (BDT ৳) price formatting

---

## 📦 Map Data Structure (Assignment Requirement)

```dart
List<Map<String, dynamic>> products = [
  {
    "name": "iPhone 15 Pro",
    "price": 149999.0,
    "icon": Icons.phone_iphone,
    "color": Color(0xFF6C3EF4),
  },
  // ...
];
```

All CRUD operations (add, search, sort) operate directly on this `List<Map<String, dynamic>>`.