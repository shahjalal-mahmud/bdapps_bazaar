import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  EmptyState  –  Shown when no products match the current search/filter.
//  Fully stateless / const-friendly.
// ─────────────────────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final bool isSearchActive;
  const EmptyState({super.key, this.isSearchActive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration circle
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF6C3EF4).withValues(alpha: 0.13),
                  const Color(0xFF6C3EF4).withValues(alpha: 0.04),
                ],
              ),
              border: Border.all(
                color: const Color(0xFF6C3EF4).withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Icon(
                isSearchActive
                    ? Icons.search_off_rounded
                    : Icons.inventory_2_outlined,
                size: 56,
                color: const Color(0xFF6C3EF4).withValues(alpha: 0.45),
              ),
            ),
          ),

          const SizedBox(height: 28),

          Text(
            isSearchActive ? 'No Results Found' : 'No Products Yet',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            isSearchActive
                ? 'Try a different keyword or clear the search to see all products.'
                : 'Tap the + button to add your first product to the bazaar.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF9E9EAE),
              height: 1.6,
            ),
          ),

          const SizedBox(height: 32),

          // Decorative pill dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == 1 ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == 1
                      ? const Color(0xFF6C3EF4)
                      : const Color(0xFF6C3EF4).withValues(alpha: 0.22),
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