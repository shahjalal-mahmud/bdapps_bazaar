import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  ProductCard  –  Premium card with minimal animation overhead.
//
//  Performance choices:
//  • Single AnimatedOpacity instead of AnimationController + Tween
//  • AnimatedScale for press feedback (no extra controller)
//  • All const colours / text styles
//  • RepaintBoundary is applied by the parent grid, not here
// ─────────────────────────────────────────────────────────────────────────────
class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final int index;

  const ProductCard({super.key, required this.product, required this.index});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _visible = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    // Tiny stagger (max 240 ms) – just enough to feel alive, not enough to feel slow
    final delay = (widget.index * 30).clamp(0, 240);
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String name   = widget.product['name']  as String;
    final double price  = widget.product['price'] as double;
    final IconData icon = widget.product['icon']  as IconData;
    final Color accent  = widget.product['color'] as Color;

    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.08),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            child: _CardBody(name: name, price: price, icon: icon, accent: accent),
          ),
        ),
      ),
    );
  }
}

// ── Stateless card body – never rebuilds on press (only the parent rebuilds) ──
class _CardBody extends StatelessWidget {
  final String name;
  final double price;
  final IconData icon;
  final Color accent;

  const _CardBody({
    required this.name,
    required this.price,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          const BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Icon area ─────────────────────────────────────────────────
          Expanded(
            flex: 5,
            child: _IconArea(accent: accent, icon: icon),
          ),

          // ── Info area ─────────────────────────────────────────────────
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  _PriceRow(price: price, accent: accent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconArea extends StatelessWidget {
  final Color accent;
  final IconData icon;
  const _IconArea({required this.accent, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.13),
            accent.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.08),
              ),
            ),
          ),
          // Icon badge
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.22),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, size: 36, color: accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final double price;
  final Color accent;
  const _PriceRow({required this.price, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            '৳',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            _formatPrice(price),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
        ),
      ],
    );
  }

  /// South Asian number format: 1,49,999
  String _formatPrice(double price) {
    final int p = price.toInt();
    if (p < 1000) return p.toString();
    final String s = p.toString();
    final String last3 = s.substring(s.length - 3);
    final String remaining = s.substring(0, s.length - 3);
    final buf = StringBuffer(last3);
    int count = 0;
    for (int i = remaining.length - 1; i >= 0; i--) {
      if (count == 2) {
        buf.write(',');
        count = 0;
      }
      buf.write(remaining[i]);
      count++;
    }
    return buf.toString().split('').reversed.join();
  }
}