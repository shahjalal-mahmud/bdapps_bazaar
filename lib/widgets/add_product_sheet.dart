import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  AddProductSheet  –  Modal bottom sheet for adding a new product.
//
//  Performance:
//  • Single AnimationController for the sheet entrance only
//  • Keyboard-aware padding via viewInsets
//  • const widgets throughout
// ─────────────────────────────────────────────────────────────────────────────
class AddProductSheet extends StatefulWidget {
  final void Function(String name, double price) onAdd;
  const AddProductSheet({super.key, required this.onAdd});

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  bool _loading = false;

  late final AnimationController _sheetCtrl;
  late final Animation<double> _sheetAnim;

  @override
  void initState() {
    super.initState();
    _sheetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    )..forward();

    _sheetAnim = CurvedAnimation(
      parent: _sheetCtrl,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _sheetCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    HapticFeedback.mediumImpact();

    // Tiny pause so the loading indicator is visible for a frame
    await Future.delayed(const Duration(milliseconds: 160));
    if (!mounted) return;

    widget.onAdd(_nameCtrl.text.trim(), double.parse(_priceCtrl.text.trim()));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedBuilder(
      animation: _sheetAnim,
      builder: (_, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(_sheetAnim),
        child: FadeTransition(opacity: _sheetAnim, child: child),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 8, 24, 24 + bottom),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 8, bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9B6BFF), Color(0xFF6C3EF4)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C3EF4).withValues(alpha: 0.30),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add_shopping_cart_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Product',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    Text(
                      'Fill in the details below',
                      style: TextStyle(
                          fontSize: 12, color: Color(0xFF9E9EAE)),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Label(text: 'Product Name', icon: Icons.label_rounded),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A2E)),
                    decoration: const InputDecoration(
                      hintText: 'e.g. Samsung Galaxy S25',
                      prefixIcon: Icon(Icons.inventory_2_rounded,
                          color: Color(0xFF6C3EF4), size: 20),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Product name is required';
                      }
                      if (val.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  const _Label(text: 'Price (BDT ৳)', icon: Icons.payments_rounded),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _priceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A2E)),
                    decoration: const InputDecoration(
                      hintText: 'e.g. 25000',
                      prefixIcon: _TakaPrefix(),
                      prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Price is required';
                      final n = double.tryParse(val.trim());
                      if (n == null) return 'Enter a valid number';
                      if (n <= 0) return 'Price must be greater than 0';
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(
                            color: Color(0xFF9E9EAE),
                            fontWeight: FontWeight.w600)),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9B6BFF), Color(0xFF6C3EF4)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C3EF4).withValues(alpha: 0.38),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _loading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_rounded,
                              color: Colors.white, size: 20),
                          SizedBox(width: 6),
                          Text(
                            'Add Product',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper const sub-widgets ──────────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  final IconData icon;
  const _Label({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6C3EF4)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

class _TakaPrefix extends StatelessWidget {
  const _TakaPrefix();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 14, right: 8),
      child: Text(
        '৳',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6C3EF4),
        ),
      ),
    );
  }
}