# BdApps Bazaar 🛍️

A modern, premium single-screen e-commerce product list Flutter app — built for the **bdapps National Android Development Bootcamp 2026** (Module 1 — Dart Foundations assignment).

---

## 📱 Project Overview

**BdApps Bazaar** is a simple single-screen shopping app where users can:

- View a list of products in a responsive grid
- Add new products dynamically via bottom sheet
- Search products instantly by name
- Sort products by name or price
- Experience a modern and beautiful Flutter UI with smooth animations

This project demonstrates Flutter UI development fundamentals, Dart collections (`List<Map<String, dynamic>>`), searching, sorting, and dynamic state management.

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

## 🗃️ Product Data Structure

This project uses Dart `Map` objects inside a `List` to manage products (assignment requirement):

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
- Clean, modern, beginner-friendly design

---

## 📸 App Features Preview

| Feature             | Description                                                |
|---------------------|------------------------------------------------------------|
| 🛒 **Product List** | Displays products in beautiful modern cards                |
| ➕ **Add Product**   | Users can add products using an animated bottom sheet form |
| 🔍 **Search**       | Instantly filter products by product name                  |
| 📊 **Sort**         | Sort by Name (A-Z/Z-A) or Price (Low-High/High-Low)        |

---

## 🧠 Technologies Used

- Flutter
- Dart
- Material 3 Design
- StatefulWidget
- List & Map Data Structures

---

## 🎯 Assignment Information

|                |                                                   |
|----------------|---------------------------------------------------|
| **Program**    | bdapps National Android Development Bootcamp 2026 |
| **Batch**      | Batch 1                                           |
| **Module**     | Module 1 — Dart Foundations                       |
| **Assignment** | 2nd Online Class Assignment                       |

---

## 🏛️ About the Bootcamp

The **National Android Development Bootcamp (NADB) 2026** is a nationwide initiative focused on:

- Android Development
- Flutter
- App Monetization
- Real-world Application Building
- Developer Community Growth

---

## 👨‍💻 Developer

**Md Shahajalal Mahmud**  
Android & Backend Developer  
Founder @ Appriyo

---

## 💙 Special Thanks

Thanks to the NADB Mentors & Organizers for organizing this incredible learning opportunity for Bangladeshi developers.

---

## ⭐ Final Note

This project represents my learning journey in Flutter and Dart during the early phase of the bootcamp. More advanced projects and features will be added as the program progresses.

---

## 📜 License

This project is created for educational and assignment purposes.
