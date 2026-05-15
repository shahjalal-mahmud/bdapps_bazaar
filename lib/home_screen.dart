import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'product_data.dart';
import 'widgets/product_card.dart';
import 'widgets/add_product_sheet.dart';
import 'widgets/empty_state.dart';
import 'widgets/sort_menu.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  HomeScreen  –  Single screen that hosts the full product-list experience.
// ─────────────────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // ── State ─────────────────────────────────────────────────────────────────

  /// Master product list (Map data structure as required)
  final List<Map<String, dynamic>> _products = ProductData.getSampleProducts();

  /// Products currently visible after applying search + sort
  List<Map<String, dynamic>> _filtered = [];

  /// Current sort mode label
  String _sortMode = SortMode.nameAZ;

  /// Search query string
  String _searchQuery = '';

  /// Counter used to pick icon/colour for newly added products
  int _addCounter = 0;

  late final TextEditingController _searchController;
  late final AnimationController _fabAnimController;
  late final Animation<double> _fabScaleAnim;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // FAB pulse animation
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fabScaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _fabAnimController, curve: Curves.easeInOut),
    );

    _applyFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabAnimController.dispose();
    super.dispose();
  }

  // ── Filter & Sort logic ───────────────────────────────────────────────────

  void _applyFilters() {
    List<Map<String, dynamic>> result = List.from(_products);

    // 1. Search filter
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((p) =>
          (p['name'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // 2. Sort
    switch (_sortMode) {
      case SortMode.nameAZ:
        result.sort((a, b) =>
            (a['name'] as String).compareTo(b['name'] as String));
        break;
      case SortMode.nameZA:
        result.sort((a, b) =>
            (b['name'] as String).compareTo(a['name'] as String));
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
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddProductSheet(
        onAdd: (String name, double price) {
          final newProduct = <String, dynamic>{
            "name": name,
            "price": price,
            "icon": ProductData.iconForIndex(_addCounter),
            "color": ProductData.colorForIndex(_addCounter),
          };
          _products.add(newProduct);
          _addCounter++;
          _applyFilters();

          // Show snackbar feedback
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '"$name" added successfully!',
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
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Gradient AppBar ───────────────────────────────────────────────
          _buildSliverAppBar(),

          // ── Search + Sort row ─────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildSearchSortRow()),

          // ── Product count chip ────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildCountRow()),

          // ── Product Grid or Empty State ───────────────────────────────────
          _filtered.isEmpty
              ? SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(isSearchActive: _searchQuery.isNotEmpty),
          )
              : SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final product = _filtered[index];
                  return ProductCard(
                    product: product,
                    index: index,
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
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnim,
        child: GestureDetector(
          onTapDown: (_) => _fabAnimController.forward(),
          onTapUp: (_) {
            _fabAnimController.reverse();
            _openAddProductSheet();
          },
          onTapCancel: () => _fabAnimController.reverse(),
          child: Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6C3EF4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C3EF4).withValues(alpha: 0.45),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }

  // ── Sliver AppBar with gradient ───────────────────────────────────────────
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      stretch: true,
      backgroundColor: const Color(0xFF6C3EF4),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
        ],
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BdApps Bazaar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              'Your Premium Marketplace',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF4F46E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -30,
                right: -20,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Positioned(
                top: 30,
                right: 60,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Icon(
                  Icons.store_rounded,
                  size: 70,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Search bar + Sort button row ──────────────────────────────────────────
  Widget _buildSearchSortRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Row(
        children: [
          // Search bar
          Expanded(
            child: Container(
              height: 50,
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
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade400,
                    size: 22,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      _onSearch('');
                    },
                    child: Icon(Icons.close_rounded,
                        color: Colors.grey.shade400, size: 20),
                  )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Sort button
          SortMenu(
            currentMode: _sortMode,
            onSortChanged: _onSortChanged,
          ),
        ],
      ),
    );
  }

  // ── Product count row ─────────────────────────────────────────────────────
  Widget _buildCountRow() {
    final total = _products.length;
    final showing = _filtered.length;
    final isFiltered = _searchQuery.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF6C3EF4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isFiltered
                  ? '$showing of $total products'
                  : '$total products',
              style: const TextStyle(
                color: Color(0xFF6C3EF4),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const Spacer(),
          if (_sortMode != SortMode.nameAZ)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sort_rounded,
                      size: 13, color: Colors.orange),
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