import 'package:flutter/material.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';
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
    final theme = Theme.of(context);
    return showModalBottomSheet<NewPurchaseResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
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

  InputDecoration _dec(String hint, {required bool isDark}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontWeight: FontWeight.w700),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12, width: 1.2),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final textPrimary = isDark ? Colors.white : const Color(0xFF0B1220);
    final textMuted = isDark ? Colors.white70 : const Color(0xFF555F71);

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
            Row(
              children: [
                Expanded(
                  child: Text(
                    'New Purchase',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: textMuted),
                ),
              ],
            ),
            verticalSpace(14),

            // Form scroll area
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label('Supplier', isDark: isDark),
                    _Dropdown<Supplier>(
                      value: _supplier,
                      items: widget.suppliers,
                      label: (s) => s.name,
                      onChanged: (v) => setState(() => _supplier = v),
                      isDark: isDark,
                      decoration: _dec('', isDark: isDark),
                    ),
                    verticalSpace(12),

                    _Label('Invoice Number', isDark: isDark),
                    TextField(
                      controller: _invoice,
                      style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
                      decoration: _dec('', isDark: isDark),
                    ),
                    verticalSpace(12),

                    _Label('Amount Paid', isDark: isDark),
                    TextField(
                      controller: _amountPaid,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
                      decoration: _dec('', isDark: isDark),
                    ),
                    verticalSpace(14),

                    Text(
                      'Products',
                      style: TextStyle(color: textMuted, fontWeight: FontWeight.w800),
                    ),
                    verticalSpace(8),

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
                          isDark: isDark,
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
                          side: BorderSide(color: isDark ? Colors.white24 : Colors.black12, width: 1.4),
                          foregroundColor: isDark ? Colors.white70 : Colors.black54,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          '+ Add Product',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    verticalSpace(18),
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
                      backgroundColor: theme.cardColor,
                      foregroundColor: textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: isDark ? BorderSide.none : const BorderSide(color: Colors.black12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w800, color: textMuted)),
                  ),
                ),
                horizontalSpace(12),
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
  final bool isDark;
  const _Label(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54, 
          fontSize: 14,
          fontWeight: FontWeight.w800
        ),
      ),
    );
  }
}

class _Dropdown<T extends Object> extends StatefulWidget {
  final T? value;
  final List<T> items;
  final String Function(T) label;
  final ValueChanged<T?> onChanged;
  final bool isDark;
  final InputDecoration decoration;

  const _Dropdown({
    required this.value,
    required this.items,
    required this.label,
    required this.onChanged,
    required this.isDark,
    required this.decoration,
  });

  @override
  State<_Dropdown<T>> createState() => _DropdownState<T>();
}

class _DropdownState<T extends Object> extends State<_Dropdown<T>> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value != null ? widget.label(widget.value!) : '');
    
    // Select all text on focus for easy replacement
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _Dropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      final newText = widget.value != null ? widget.label(widget.value!) : '';
      if (_controller.text != newText) {
        _controller.text = newText;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
        color: widget.isDark ? Colors.white : const Color(0xFF0B1220), 
        fontWeight: FontWeight.w700);

    return LayoutBuilder(builder: (context, constraints) {
      return RawAutocomplete<T>(
        textEditingController: _controller,
        focusNode: _focusNode,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return widget.items;
          }
          return widget.items.where((T option) {
            return widget.label(option).toLowerCase().contains(textEditingValue.text.toLowerCase());
          });
        },
        displayStringForOption: widget.label,
        onSelected: widget.onChanged,
        fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
          return TextField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            style: textStyle,
            decoration: widget.decoration.copyWith(
              suffixIcon: Icon(Icons.arrow_drop_down,
                  color: widget.isDark ? Colors.white54 : Colors.black54),
            ),
          );
        },
        optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<T> onSelected, Iterable<T> options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: constraints.maxWidth,
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final T option = options.elementAt(index);
                    return ListTile(
                      title: Text(widget.label(option), style: textStyle),
                      onTap: () => onSelected(option),
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    });
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
  final InputDecoration Function(String, {required bool isDark}) dec;
  final bool isDark;

  const _ProductLine({
    required this.catalog,
    required this.ctrl,
    required this.onRemove,
    required this.dec,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final text = isDark ? Colors.white : const Color(0xFF0B1220);

    return Column(
      children: [
        // Product + Qty
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _Dropdown<Product>(
                value: ctrl.product,
                items: catalog,
                label: (p) => p.name,
                onChanged: (v) {
                  ctrl.product = v;
                  (context as Element).markNeedsBuild();
                },
                isDark: isDark,
                decoration: dec('', isDark: isDark),
              ),
            ),
            horizontalSpace(12),
            SizedBox(
              width: 90,
              child: TextField(
                controller: ctrl.qty,
                keyboardType: TextInputType.number,
                style: TextStyle(color: text, fontWeight: FontWeight.w700),
                decoration: dec('Qty', isDark: isDark),
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
                style: TextStyle(color: text, fontWeight: FontWeight.w700),
                decoration: dec('Cost', isDark: isDark),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: ctrl.sell,
                keyboardType: TextInputType.number,
                style: TextStyle(color: text, fontWeight: FontWeight.w700),
                decoration: dec('Sell', isDark: isDark),
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
