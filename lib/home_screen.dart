import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'product_data.dart';
import 'widgets/product_card.dart';
import 'widgets/add_product_sheet.dart';
import 'widgets/empty_state.dart';
import 'widgets/sort_menu.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  HomeScreen  –  Single screen with product list, search, sort, add.
// ─────────────────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ── State ─────────────────────────────────────────────────────────────────

  /// Master product list – Map data structure as required by assignment
  final List<Map<String, dynamic>> _products =
  ProductData.getSampleProducts();

  List<Map<String, dynamic>> _filtered = [];
  String _sortMode = SortMode.nameAZ;
  String _searchQuery = '';
  int _addCounter = 0;

  late final TextEditingController _searchController;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _applyFilters(); // build initial filtered list
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Filter & Sort ─────────────────────────────────────────────────────────

  void _applyFilters() {
    List<Map<String, dynamic>> result = List.from(_products);

    // 1. Search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where((p) => (p['name'] as String).toLowerCase().contains(q))
          .toList();
    }

    // 2. Sort
    switch (_sortMode) {
      case SortMode.nameAZ:
        result.sort(
                (a, b) => (a['name'] as String).compareTo(b['name'] as String));
        break;
      case SortMode.nameZA:
        result.sort(
                (a, b) => (b['name'] as String).compareTo(a['name'] as String));
        break;
      case SortMode.priceLow:
        result.sort((a, b) =>
            (a['price'] as double).compareTo(b['price'] as double));
        break;
      case SortMode.priceHigh:
        result.sort((a, b) =>
            (b['price'] as double).compareTo(a['price'] as double));
        break;
    }

    setState(() => _filtered = result);
  }

  void _onSearch(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _onSortChanged(String mode) {
    _sortMode = mode;
    _applyFilters();
  }

  // ── Add product ───────────────────────────────────────────────────────────

  void _openAddProductSheet() {
    // Light haptic – instant feedback before sheet opens
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // useSafeArea keeps it above the nav bar
      useSafeArea: true,
      builder: (_) => AddProductSheet(
        onAdd: (String name, double price) {
          _products.add(<String, dynamic>{
            "name": name,
            "price": price,
            "icon": ProductData.iconForIndex(_addCounter),
            "color": ProductData.colorForIndex(_addCounter),
          });
          _addCounter++;
          _applyFilters();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '"$name" added!',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF6C3EF4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: CustomScrollView(
        // ClampingScrollPhysics is snappier on Android than Bouncing
        physics: const ClampingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildSearchSortRow()),
          SliverToBoxAdapter(child: _buildCountRow()),
          _filtered.isEmpty
              ? SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(isSearchActive: _searchQuery.isNotEmpty),
          )
              : SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  // RepaintBoundary isolates each card's repaint layer
                  return RepaintBoundary(
                    child: ProductCard(
                      product: _filtered[index],
                      index: index,
                    ),
                  );
                },
                childCount: _filtered.length,
              ),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.78,
              ),
            ),
          ),
        ],
      ),

      // ── FAB ───────────────────────────────────────────────────────────────
      floatingActionButton: _PremiumFab(onTap: _openAddProductSheet),
    );
  }

  // ── Widgets ───────────────────────────────────────────────────────────────

  Widget _buildSliverAppBar() {
    return const SliverAppBar(
      expandedHeight: 170,
      pinned: true,
      stretch: true,
      backgroundColor: Color(0xFF5B3FE4),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
        ],
        titlePadding: EdgeInsets.only(left: 20, bottom: 18),
        title: _AppBarTitle(),
        background: _AppBarBackground(),
      ),
    );
  }

  Widget _buildSearchSortRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Row(
        children: [
          Expanded(child: _SearchBar(controller: _searchController, onChanged: _onSearch, query: _searchQuery)),
          const SizedBox(width: 10),
          SortMenu(currentMode: _sortMode, onSortChanged: _onSortChanged),
        ],
      ),
    );
  }

  Widget _buildCountRow() {
    final total = _products.length;
    final showing = _filtered.length;
    final isFiltered = _searchQuery.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        children: [
          // Count chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF6C3EF4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isFiltered ? '$showing of $total products' : '$total products',
              style: const TextStyle(
                color: Color(0xFF6C3EF4),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const Spacer(),

          // Active sort chip (only when not default)
          if (_sortMode != SortMode.nameAZ)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sort_rounded, size: 13, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    _sortMode,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Private sub-widgets extracted so the main build method stays clean
//  and each widget can be independently compared / updated.
// ─────────────────────────────────────────────────────────────────────────────

/// Gradient AppBar title column – const-constructible
class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BdApps Bazaar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
        Text(
          'Your Premium Marketplace',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 10.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

/// Gradient AppBar background – kept as const widget so it never rebuilds
class _AppBarBackground extends StatelessWidget {
  const _AppBarBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF4F46E5), Color(0xFF3730A3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -24,
            right: -16,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            top: 28,
            right: 60,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 20,
            child: Icon(
              Icons.storefront_rounded,
              size: 72,
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
          // Small dot grid
          Positioned(
            top: 18,
            left: 16,
            child: Opacity(
              opacity: 0.18,
              child: _buildDots(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Column(
      children: List.generate(3, (r) {
        return Row(
          children: List.generate(4, (c) {
            return Container(
              margin: const EdgeInsets.all(4),
              width: 3,
              height: 3,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            );
          }),
        );
      }),
    );
  }
}

/// Search bar extracted to its own widget to avoid rebuilding the whole
/// screen when the suffix icon changes (only this widget rebuilds).
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String query;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: const TextStyle(color: Color(0xFFB0B3C5), fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded,
              color: Color(0xFFB0B3C5), size: 22),
          suffixIcon: query.isNotEmpty
              ? GestureDetector(
            onTap: () => onChanged(''),
            child: const Icon(Icons.close_rounded,
                color: Color(0xFFB0B3C5), size: 20),
          )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
      ),
    );
  }
}

/// Premium FAB – uses InkWell + AnimatedScale for instant, smooth response
class _PremiumFab extends StatefulWidget {
  final VoidCallback onTap;
  const _PremiumFab({required this.onTap});

  @override
  State<_PremiumFab> createState() => _PremiumFabState();
}

class _PremiumFabState extends State<_PremiumFab> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.91 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF9B6BFF), Color(0xFF6C3EF4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C3EF4).withValues(alpha: 0.42),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}