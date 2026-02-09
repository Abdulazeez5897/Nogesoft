import 'package:flutter/material.dart';
import 'package:nogesoft/ui/common/ui_helpers.dart';

class StoreProductDialogResult {
  final String name;
  final String category;
  final int price;
  final int stock;
  final String unit;
  final String dimensions;
  final DateTime? date;

  const StoreProductDialogResult({
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.unit,
    required this.dimensions,
    required this.date,
  });
}

class StoreProductDialog extends StatefulWidget {
  final String title;
  final String? initialName;
  final String? initialCategory;
  final int? initialPrice;
  final int? initialStock;
  final String initialUnit;
  final String? initialDimensions;
  final DateTime? initialDate;

  const StoreProductDialog({
    super.key,
    required this.title,
    this.initialName,
    this.initialCategory,
    this.initialPrice,
    this.initialStock,
    this.initialUnit = 'pcs',
    this.initialDimensions,
    this.initialDate,
  });

  static Future<StoreProductDialogResult?> show(
      BuildContext context, {
        required String title,
        String? initialName,
        String? initialCategory,
        int? initialPrice,
        int? initialStock,
        String initialUnit = 'pcs',
        String? initialDimensions,
        DateTime? initialDate,
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
        initialUnit: initialUnit,
        initialDimensions: initialDimensions,
        initialDate: initialDate,
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
  late final TextEditingController _dimensions;

  late String _unit;
  late DateTime _selectedDate;

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
    _dimensions = TextEditingController(text: widget.initialDimensions ?? '');
    
    _unit = widget.initialUnit;
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _name.dispose();
    _category.dispose();
    _price.dispose();
    _stock.dispose();
    _dimensions.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF38B24A), width: 1.5),
      ),
    );
  }

  void _onSave() {
    final name = _name.text.trim();
    final category = _category.text.trim();
    final price = int.tryParse(_price.text.trim()) ?? 0;
    final stock = int.tryParse(_stock.text.trim()) ?? 0;
    final dims = _dimensions.text.trim();

    if (name.isEmpty || category.isEmpty) {
      return;
    }

    Navigator.of(context).pop(
      StoreProductDialogResult(
        name: name,
        category: category,
        price: price,
        stock: stock,
        unit: _unit,
        dimensions: dims,
        date: _selectedDate,
      ),
    );
  }

  Future<void> _pickDate() async {
    final theme = Theme.of(context);
    // Use standard theme for picker
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: const Color(0xFF38B24A),
            ),
          ),
          child: child!,
        );
      }
    );
    if (d != null) {
      setState(() => _selectedDate = d);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0B1220);
    final borderColor = isDark ? Colors.white12 : Colors.black12;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                widget.title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              verticalSpace(18),

              TextField(
                controller: _name,
                style: TextStyle(color: textColor),
                decoration: _fieldDecoration('Name', isDark),
                textInputAction: TextInputAction.next,
              ),
              verticalSpace(12),

              TextField(
                controller: _category,
                style: TextStyle(color: textColor),
                decoration: _fieldDecoration('Category', isDark),
                textInputAction: TextInputAction.next,
              ),
              verticalSpace(12),

              Row(children: [
                Expanded(
                  child: TextField(
                    controller: _price,
                    style: TextStyle(color: textColor),
                    decoration: _fieldDecoration('Price', isDark),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: TextField(
                    controller: _stock,
                    style: TextStyle(color: textColor),
                    decoration: _fieldDecoration('Stock', isDark),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ]),
              verticalSpace(12),

              // Dimensions Input
              TextField(
                controller: _dimensions,
                style: TextStyle(color: textColor),
                decoration: _fieldDecoration('Dimensions (e.g. 10x12)', isDark),
                textInputAction: TextInputAction.done,
              ),
              verticalSpace(14),

              // Unit Dropdown + Date Picker Row
              Row(
                children: [
                  // Unit Dropdown
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _unit,
                          dropdownColor: theme.cardColor,
                          icon: Icon(Icons.unfold_more, color: isDark ? Colors.white54 : Colors.black54),
                          style: TextStyle(color: textColor),
                          items: [
                            'pcs', 'kg', 'ltr'
                          ].map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, style: TextStyle(color: textColor)),
                          )).toList(),
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => _unit = v);
                          },
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(12),
                  // Date Picker Button
                  Expanded(
                    child: InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           border: Border.all(color: borderColor),
                         ),
                         child: Text(
                           "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                           textAlign: TextAlign.center,
                           style: TextStyle(color: textColor),
                         ),
                      ),
                    ),
                  ),
                ],
              ),

              verticalSpace(24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _DialogButton(
                    label: 'Cancel',
                    isPrimary: false,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  horizontalSpace(12),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final bg = isPrimary 
        ? const Color(0xFF38B24A) 
        : (isDark ? const Color(0xFF141E31) : const Color(0xFFE0E0E0));
        
    final fg = isPrimary 
        ? Colors.white 
        : (isDark ? Colors.white70 : Colors.black87);

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
