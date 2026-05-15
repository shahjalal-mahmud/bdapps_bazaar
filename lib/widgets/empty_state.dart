import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  EmptyState  –  Shown when no products match the current search/filter.
// ─────────────────────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  /// True when the empty state is caused by a search returning no results
  final bool isSearchActive;

  const EmptyState({super.key, this.isSearchActive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Illustration ───────────────────────────────────────────────
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF6C3EF4).withValues(alpha: 0.12),
                  const Color(0xFF6C3EF4).withValues(alpha: 0.04),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                isSearchActive
                    ? Icons.search_off_rounded
                    : Icons.inventory_2_outlined,
                size: 60,
                color: const Color(0xFF6C3EF4).withValues(alpha: 0.5),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ── Title ──────────────────────────────────────────────────────
          Text(
            isSearchActive ? 'No Results Found' : 'No Products Yet',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),

          const SizedBox(height: 10),

          // ── Subtitle ───────────────────────────────────────────────────
          Text(
            isSearchActive
                ? 'Try a different keyword or clear your search to see all products.'
                : 'Tap the + button below to add your first product to the bazaar.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 32),

          // ── Decorative dots ────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == 1 ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == 1
                      ? const Color(0xFF6C3EF4)
                      : const Color(0xFF6C3EF4).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}