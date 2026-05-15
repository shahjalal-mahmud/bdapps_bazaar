import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  AddProductSheet  –  Modal bottom sheet for adding a new product.
//
//  Validates:
//    • Name must not be empty
//    • Price must be a positive number
// ─────────────────────────────────────────────────────────────────────────────
class AddProductSheet extends StatefulWidget {
  /// Callback fired with (name, price) when the form is submitted
  final void Function(String name, double price) onAdd;

  const AddProductSheet({super.key, required this.onAdd});

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();

    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _submit() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    HapticFeedback.mediumImpact();

    // Small delay for visual feedback
    await Future.delayed(const Duration(milliseconds: 200));

    final name = _nameController.text.trim();
    final price = double.parse(_priceController.text.trim());

    widget.onAdd(name, price);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Padding accounts for the keyboard
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return ScaleTransition(
      scale: _scaleAnim,
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 8, 24, 24 + bottomInset),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Drag handle ───────────────────────────────────────────────
            Center(
              child: Container(
                width: 42,
                height: 5,
                margin: const EdgeInsets.only(top: 8, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            // ── Header ────────────────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF6C3EF4)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_shopping_cart_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Add New Product',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    Text(
                      'Fill in the details below',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Form ──────────────────────────────────────────────────────
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Product Name field
                  _buildLabel('Product Name', Icons.inventory_2_rounded),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        fontSize: 15, color: Color(0xFF1A1A2E)),
                    decoration: const InputDecoration(
                      hintText: 'e.g. Samsung Galaxy S25',
                      prefixIcon: Icon(Icons.label_rounded,
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

                  // Price field
                  _buildLabel('Price (BDT ৳)', Icons.payments_rounded),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    style: const TextStyle(
                        fontSize: 15, color: Color(0xFF1A1A2E)),
                    decoration: const InputDecoration(
                      hintText: 'e.g. 25000',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 14, right: 8),
                        child: Text(
                          '৳',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6C3EF4),
                          ),
                        ),
                      ),
                      prefixIconConstraints:
                      BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Price is required';
                      }
                      final parsed = double.tryParse(val.trim());
                      if (parsed == null) {
                        return 'Enter a valid number';
                      }
                      if (parsed <= 0) {
                        return 'Price must be greater than 0';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Buttons ───────────────────────────────────────────────────
            Row(
              children: [
                // Cancel
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Add button
                Expanded(
                  flex: 2,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF6C3EF4)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C3EF4).withOpacity(0.4),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
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

  Widget _buildLabel(String text, IconData icon) {
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