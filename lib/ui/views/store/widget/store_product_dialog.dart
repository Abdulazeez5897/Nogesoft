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

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white12),
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
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
             colorScheme: const ColorScheme.dark(
               primary: Color(0xFF38B24A),
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
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      backgroundColor: const Color(0xFF0E1626),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              verticalSpace(18),

              TextField(
                controller: _name,
                style: const TextStyle(color: Colors.white),
                decoration: _fieldDecoration('Name'),
                textInputAction: TextInputAction.next,
              ),
              verticalSpace(12),

              TextField(
                controller: _category,
                style: const TextStyle(color: Colors.white),
                decoration: _fieldDecoration('Category'),
                textInputAction: TextInputAction.next,
              ),
              verticalSpace(12),

              Row(children: [
                Expanded(
                  child: TextField(
                    controller: _price,
                    style: const TextStyle(color: Colors.white),
                    decoration: _fieldDecoration('Price'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: TextField(
                    controller: _stock,
                    style: const TextStyle(color: Colors.white),
                    decoration: _fieldDecoration('Stock'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ]),
              verticalSpace(12),

              // Dimensions Input
              TextField(
                controller: _dimensions,
                style: const TextStyle(color: Colors.white),
                decoration: _fieldDecoration('Dimensions (e.g. 10x12)'),
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
                        border: Border.all(color: Colors.white12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _unit,
                          dropdownColor: const Color(0xFF0E1626),
                          icon: const Icon(Icons.unfold_more, color: Colors.white54),
                          items: const [
                            DropdownMenuItem(value: 'pcs', child: Text('pcs', style: TextStyle(color: Colors.white))),
                            DropdownMenuItem(value: 'kg', child: Text('kg', style: TextStyle(color: Colors.white))),
                            DropdownMenuItem(value: 'ltr', child: Text('ltr', style: TextStyle(color: Colors.white))),
                          ],
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
                           border: Border.all(color: Colors.white12),
                         ),
                         child: Text(
                           "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                           textAlign: TextAlign.center,
                           style: const TextStyle(color: Colors.white),
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
