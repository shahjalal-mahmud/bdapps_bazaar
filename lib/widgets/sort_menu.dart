import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  SortMode constants  –  shared between HomeScreen and SortMenu
// ─────────────────────────────────────────────────────────────────────────────
class SortMode {
  static const String nameAZ    = 'Name A→Z';
  static const String nameZA    = 'Name Z→A';
  static const String priceLow  = 'Price ↑';
  static const String priceHigh = 'Price ↓';
}

// ─────────────────────────────────────────────────────────────────────────────
//  SortMenu  –  Popup menu for choosing sort order.
//  Fully stateless – no rebuild cost.
// ─────────────────────────────────────────────────────────────────────────────
class SortMenu extends StatelessWidget {
  final String currentMode;
  final void Function(String mode) onSortChanged;

  const SortMenu({
    super.key,
    required this.currentMode,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSortChanged,
      offset: const Offset(0, 56),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      color: Colors.white,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.tune_rounded, color: Color(0xFF6C3EF4), size: 22),
      ),
      itemBuilder: (_) => [
        _header('SORT BY'),
        _item(SortMode.nameAZ,    Icons.sort_by_alpha_rounded),
        _item(SortMode.nameZA,    Icons.sort_by_alpha_rounded),
        _item(SortMode.priceLow,  Icons.trending_up_rounded),
        _item(SortMode.priceHigh, Icons.trending_down_rounded),
      ],
    );
  }

  PopupMenuEntry<String> _header(String label) {
    return PopupMenuItem<String>(
      enabled: false,
      height: 34,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Color(0xFFB0B3C5),
          letterSpacing: 1.4,
        ),
      ),
    );
  }

  PopupMenuItem<String> _item(String mode, IconData icon) {
    final bool active = currentMode == mode;
    return PopupMenuItem<String>(
      value: mode,
      height: 46,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFF6C3EF4).withValues(alpha: 0.12)
                  : const Color(0xFFF4F4F8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: active ? const Color(0xFF6C3EF4) : const Color(0xFFB0B3C5),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            mode,
            style: TextStyle(
              fontSize: 14,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? const Color(0xFF6C3EF4) : const Color(0xFF1A1A2E),
            ),
          ),
          const Spacer(),
          if (active)
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF6C3EF4),
              ),
            ),
        ],
      ),
    );
  }
}