import 'package:flutter/material.dart';

class StoreProductDialogResult {
  final String name;
  final String category;
  final int price;
  final int stock;
  final String dimension;

  const StoreProductDialogResult({
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.dimension,
  });
}

class StoreProductDialog extends StatefulWidget {
  final String title;
  final String? initialName;
  final String? initialCategory;
  final int? initialPrice;
  final int? initialStock;
  final String initialDimension;

  const StoreProductDialog({
    super.key,
    required this.title,
    this.initialName,
    this.initialCategory,
    this.initialPrice,
    this.initialStock,
    this.initialDimension = 'pcs',
  });

  static Future<StoreProductDialogResult?> show(
      BuildContext context, {
        required String title,
        String? initialName,
        String? initialCategory,
        int? initialPrice,
        int? initialStock,
        String initialDimension = 'pcs',
      }) {
    return showDialog<StoreProductDialogResult>(
      context: context,
      barrierDismissible: true,
      builder: (_) => StoreProductDialog(
        title: title,
        initialName: initialName,
        initialCategory: initialCategory,
        initialPrice: initialPrice,
        initialStock: initialStock,
        initialDimension: initialDimension,
      ),
    );
  }

  @override
  State<StoreProductDialog> createState() => _StoreProductDialogState();
}

class _StoreProductDialogState extends State<StoreProductDialog> {
  late final TextEditingController _name;
  late final TextEditingController _category;
  late final TextEditingController _price;
  late final TextEditingController _stock;

  late String _dimension;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialName ?? '');
    _category = TextEditingController(text: widget.initialCategory ?? '');
    _price = TextEditingController(
      text: widget.initialPrice == null ? '' : widget.initialPrice.toString(),
    );
    _stock = TextEditingController(
      text: widget.initialStock == null ? '' : widget.initialStock.toString(),
    );
    _dimension = widget.initialDimension;
  }

  @override
  void dispose() {
    _name.dispose();
    _category.dispose();
    _price.dispose();
    _stock.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2F6BFF), width: 2),
      ),
    );
  }

  void _onSave() {
    final name = _name.text.trim();
    final category = _category.text.trim();
    final price = int.tryParse(_price.text.trim()) ?? 0;
    final stock = int.tryParse(_stock.text.trim()) ?? 0;

    if (name.isEmpty || category.isEmpty) {
      // Keep it simple, no extra UI not shown in the video.
      return;
    }

    Navigator.of(context).pop(
      StoreProductDialogResult(
        name: name,
        category: category,
        price: price,
        stock: stock,
        dimension: _dimension,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      backgroundColor: const Color(0xFF0E1626),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),

            TextField(
              controller: _name,
              style: const TextStyle(color: Colors.white),
              decoration: _fieldDecoration('Name'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _category,
              style: const TextStyle(color: Colors.white),
              decoration: _fieldDecoration('Category'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _price,
              style: const TextStyle(color: Colors.white),
              decoration: _fieldDecoration('Price'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _stock,
              style: const TextStyle(color: Colors.white),
              decoration: _fieldDecoration('Stock'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 14),

            const Text(
              'Dimention',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
              child: Row(
                children: [
                  Text(
                    _dimension,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Spacer(),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _dimension,
                      dropdownColor: const Color(0xFF0E1626),
                      icon: const Icon(Icons.unfold_more, color: Colors.white54),
                      items: const [
                        DropdownMenuItem(value: 'pcs', child: Text('pcs')),
                        DropdownMenuItem(value: 'kg', child: Text('kg')),
                        DropdownMenuItem(value: 'ltr', child: Text('ltr')),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _dimension = v);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _DialogButton(
                  label: 'Cancel',
                  isPrimary: false,
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                _DialogButton(
                  label: 'Save',
                  isPrimary: true,
                  onTap: _onSave,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isPrimary ? const Color(0xFF38B24A) : const Color(0xFF141E31);
    final fg = isPrimary ? Colors.white : Colors.white70;

    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: bg,
          foregroundColor: fg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
