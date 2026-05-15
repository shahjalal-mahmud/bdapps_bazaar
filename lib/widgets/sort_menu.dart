import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  SortMode constants  –  used both in HomeScreen and SortMenu
// ─────────────────────────────────────────────────────────────────────────────
class SortMode {
  static const String nameAZ   = 'Name A→Z';
  static const String nameZA   = 'Name Z→A';
  static const String priceLow = 'Price ↑';
  static const String priceHigh = 'Price ↓';
}

// ─────────────────────────────────────────────────────────────────────────────
//  SortMenu  –  Popup menu button for choosing sort order.
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
      offset: const Offset(0, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      color: Colors.white,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.tune_rounded,
          color: Color(0xFF6C3EF4),
          size: 22,
        ),
      ),
      itemBuilder: (_) => [
        _buildHeader('Sort By'),
        _buildItem(SortMode.nameAZ,   Icons.sort_by_alpha_rounded),
        _buildItem(SortMode.nameZA,   Icons.sort_by_alpha_rounded),
        _buildItem(SortMode.priceLow, Icons.trending_up_rounded),
        _buildItem(SortMode.priceHigh,Icons.trending_down_rounded),
      ],
    );
  }

  // ── Non-selectable header item ─────────────────────────────────────────────
  PopupMenuEntry<String> _buildHeader(String title) {
    return PopupMenuItem<String>(
      enabled: false,
      height: 36,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // ── Selectable sort option ─────────────────────────────────────────────────
  PopupMenuItem<String> _buildItem(String mode, IconData icon) {
    final bool isActive = currentMode == mode;
    return PopupMenuItem<String>(
      value: mode,
      height: 46,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF6C3EF4).withValues(alpha: 0.12)
                  : Colors.grey.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: isActive ? const Color(0xFF6C3EF4) : Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            mode,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? const Color(0xFF6C3EF4) : const Color(0xFF1A1A2E),
            ),
          ),
          const Spacer(),
          if (isActive)
            Container(
              width: 8,
              height: 8,
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