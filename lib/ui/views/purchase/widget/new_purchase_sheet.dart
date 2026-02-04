import 'package:flutter/material.dart';

import 'package:nogesoft/core/data/models/product.dart';
import 'package:nogesoft/core/data/models/purchase.dart';

class NewPurchaseResult {
  final Supplier supplier;
  final String invoiceNumber;
  final int amountPaid;
  final List<PurchaseItem> items;

  const NewPurchaseResult({
    required this.supplier,
    required this.invoiceNumber,
    required this.amountPaid,
    required this.items,
  });
}

class NewPurchaseSheet extends StatefulWidget {
  final List<Supplier> suppliers;
  final List<Product> catalog; 

  const NewPurchaseSheet({
    super.key,
    required this.suppliers,
    required this.catalog,
  });

  static Future<NewPurchaseResult?> show(
      BuildContext context, {
        required List<Supplier> suppliers,
        required List<Product> catalog,
      }) {
    return showModalBottomSheet<NewPurchaseResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0E1626),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (_) => NewPurchaseSheet(suppliers: suppliers, catalog: catalog),
    );
  }

  @override
  State<NewPurchaseSheet> createState() => _NewPurchaseSheetState();
}

class _NewPurchaseSheetState extends State<NewPurchaseSheet> {
  Supplier? _supplier;
  final _invoice = TextEditingController();
  final _amountPaid = TextEditingController();

  final List<_LineControllers> _lines = [];

  @override
  void initState() {
    super.initState();
    _supplier = widget.suppliers.isNotEmpty ? widget.suppliers.first : null;
    _lines.add(_LineControllers(product: widget.catalog.isNotEmpty ? widget.catalog.first : null));
  }

  @override
  void dispose() {
    _invoice.dispose();
    _amountPaid.dispose();
    for (final l in _lines) {
      l.dispose();
    }
    super.dispose();
  }

  InputDecoration _dec(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38, fontWeight: FontWeight.w700),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2F6BFF), width: 2),
      ),
    );
  }

  void _addProductLine() {
    setState(() {
      _lines.add(_LineControllers(product: widget.catalog.isNotEmpty ? widget.catalog.first : null));
    });
  }

  void _removeLine(int index) {
    setState(() {
      _lines[index].dispose();
      _lines.removeAt(index);
      if (_lines.isEmpty) {
        _lines.add(_LineControllers(product: widget.catalog.isNotEmpty ? widget.catalog.first : null));
      }
    });
  }

  void _onSave() {
    if (_supplier == null) {
      _showError('Please select a supplier');
      return;
    }
    final invoice = _invoice.text.trim();
    if (invoice.isEmpty) {
      _showError('Please enter an invoice number');
      return;
    }

    final paid = int.tryParse(_amountPaid.text.trim()) ?? 0;

    final items = <PurchaseItem>[];
    for (final l in _lines) {
      final p = l.product;
      if (p == null) continue;
      final qty = int.tryParse(l.qty.text.trim()) ?? 0;
      final cost = int.tryParse(l.cost.text.trim()) ?? 0;
      final sell = int.tryParse(l.sell.text.trim()) ?? 0;

      if (qty <= 0) continue;

      items.add(PurchaseItem(product: p, qty: qty, cost: cost, sell: sell));
    }

    if (items.isEmpty) {
      _showError('Please add at least one valid product');
      return;
    }

    Navigator.of(context).pop(
      NewPurchaseResult(
        supplier: _supplier!,
        invoiceNumber: invoice,
        amountPaid: paid,
        items: items,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFE04B5A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 14,
          bottom: 14 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'New Purchase',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Form scroll area
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Label('Supplier'),
                    _Dropdown<Supplier>(
                      value: _supplier,
                      items: widget.suppliers,
                      label: (s) => s.name,
                      onChanged: (v) => setState(() => _supplier = v),
                    ),
                    const SizedBox(height: 12),

                    const _Label('Invoice Number'),
                    TextField(
                      controller: _invoice,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      decoration: _dec(''),
                    ),
                    const SizedBox(height: 12),

                    const _Label('Amount Paid'),
                    TextField(
                      controller: _amountPaid,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      decoration: _dec(''),
                    ),
                    const SizedBox(height: 14),

                    const Text(
                      'Products',
                      style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),

                    // Lines
                    ...List.generate(_lines.length, (i) {
                      final l = _lines[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _ProductLine(
                          catalog: widget.catalog,
                          ctrl: l,
                          onRemove: () => _removeLine(i),
                          dec: _dec,
                        ),
                      );
                    }),

                    // Add Product button
                    SizedBox(
                      height: 44,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _addProductLine,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white24, width: 1.4),
                          foregroundColor: Colors.white70,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          '+ Add Product',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),

            // Bottom actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF141E31),
                      foregroundColor: Colors.white70,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF38B24A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w900)),
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

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String Function(T) label;
  final ValueChanged<T?> onChanged;

  const _Dropdown({
    required this.value,
    required this.items,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF0E1626),
          icon: const Icon(Icons.unfold_more, color: Colors.white54),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          items: items
              .map((e) => DropdownMenuItem<T>(value: e, child: Text(label(e))))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _LineControllers {
  Product? product;
  final TextEditingController qty = TextEditingController();
  final TextEditingController cost = TextEditingController();
  final TextEditingController sell = TextEditingController();

  _LineControllers({required this.product});

  void dispose() {
    qty.dispose();
    cost.dispose();
    sell.dispose();
  }
}

class _ProductLine extends StatelessWidget {
  final List<Product> catalog;
  final _LineControllers ctrl;
  final VoidCallback onRemove;
  final InputDecoration Function(String) dec;

  const _ProductLine({
    required this.catalog,
    required this.ctrl,
    required this.onRemove,
    required this.dec,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Product + Qty
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Product>(
                    value: ctrl.product,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF0E1626),
                    icon: const Icon(Icons.unfold_more, color: Colors.white54, size: 18),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    items: catalog
                        .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                        .toList(),
                    onChanged: (v) {
                      // handled by parent; simplest: mutate controller and rebuild via ancestor setState
                      ctrl.product = v;
                      (context as Element).markNeedsBuild();
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 90,
              child: TextField(
                controller: ctrl.qty,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                decoration: dec('Qty'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Cost + Sell
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: ctrl.cost,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                decoration: dec('Cost'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: ctrl.sell,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                decoration: dec('Sell'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Remove
        SizedBox(
          height: 44,
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onRemove,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE04B5A), width: 1.6),
              foregroundColor: const Color(0xFFE04B5A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Remove', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ),
      ],
    );
  }
}
