import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  ProductData
//
//  Uses List<Map<String, dynamic>> as required by the assignment.
//  Each map has:
//    "name"  → String   : product display name
//    "price" → double   : price in BDT
//    "icon"  → IconData : Material icon (product image placeholder)
//    "color" → Color    : accent colour used in the card gradient
// ─────────────────────────────────────────────────────────────────────────────
class ProductData {
  // ── Sample seed products ──────────────────────────────────────────────────
  static List<Map<String, dynamic>> getSampleProducts() {
    return [
      {
        "name": "iPhone 15 Pro",
        "price": 149999.0,
        "icon": Icons.phone_iphone,
        "color": const Color(0xFF6C3EF4),
      },
      {
        "name": "Samsung Galaxy S24",
        "price": 119999.0,
        "icon": Icons.smartphone,
        "color": const Color(0xFF1A73E8),
      },
      {
        "name": "Sony WH-1000XM5",
        "price": 39999.0,
        "icon": Icons.headphones,
        "color": const Color(0xFF00897B),
      },
      {
        "name": "Apple MacBook Air M3",
        "price": 189999.0,
        "icon": Icons.laptop_mac,
        "color": const Color(0xFFE53935),
      },
      {
        "name": "iPad Pro 12.9\"",
        "price": 129999.0,
        "icon": Icons.tablet_mac,
        "color": const Color(0xFFF4511E),
      },
      {
        "name": "Apple Watch Series 9",
        "price": 59999.0,
        "icon": Icons.watch,
        "color": const Color(0xFF8E24AA),
      },
      {
        "name": "Canon EOS R50",
        "price": 89999.0,
        "icon": Icons.camera_alt,
        "color": const Color(0xFF039BE5),
      },
      {
        "name": "JBL Flip 6 Speaker",
        "price": 12999.0,
        "icon": Icons.speaker,
        "color": const Color(0xFF43A047),
      },
    ];
  }

  // ── Icon + colour pools for newly added products ───────────────────────────
  static const List<IconData> _iconPool = [
    Icons.devices,
    Icons.shopping_bag,
    Icons.star,
    Icons.local_offer,
    Icons.card_giftcard,
    Icons.inventory_2,
    Icons.workspace_premium,
    Icons.bolt,
    Icons.new_releases,
    Icons.auto_awesome,
  ];

  static const List<Color> _colorPool = [
    Color(0xFF6C3EF4),
    Color(0xFF1A73E8),
    Color(0xFF00897B),
    Color(0xFFE53935),
    Color(0xFFF4511E),
    Color(0xFF8E24AA),
    Color(0xFF039BE5),
    Color(0xFF43A047),
    Color(0xFFFF6F00),
    Color(0xFF546E7A),
  ];

  static IconData iconForIndex(int index) => _iconPool[index % _iconPool.length];
  static Color colorForIndex(int index)   => _colorPool[index % _colorPool.length];
}