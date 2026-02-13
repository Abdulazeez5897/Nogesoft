
import 'package:nogesoft/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

class NewCustomerResult {
  final String name;
  final String address;
  final String phone;
  final double initialDebt; // if Total > AmountPaid

  const NewCustomerResult({
    required this.name,
    required this.address,
    required this.phone,
    this.initialDebt = 0.0,
  });
}

class NewCustomerDialog extends StatefulWidget {
  const NewCustomerDialog({super.key});

  static Future<NewCustomerResult?> show(BuildContext context) {
    return showDialog<NewCustomerResult>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const NewCustomerDialog(),
    );
  }

  @override
  State<NewCustomerDialog> createState() => _NewCustomerDialogState();
}

class _NewCustomerDialogState extends State<NewCustomerDialog> {
  int _step = 1; // 1=Customer, 2=Payment

  final _name = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();

  // Payment (mock only; UI match)
  String _selectedProduct = 'Choose product';
  String _paymentType = 'Select type';
  final _discount = TextEditingController(text: '0');
  final _amountPaid = TextEditingController();
  final _description = TextEditingController();

  double get _subtotal {
    // Mock prices based on selection
    if (_selectedProduct.contains('Amarya')) return 3000;
    if (_selectedProduct.contains('Vital')) return 105000;
    return 0;
  }

  double get _finalTotal {
     final d = double.tryParse(_discount.text.trim()) ?? 0;
     return (_subtotal - d).clamp(0, double.infinity);
  }

  @override
  void initState() {
     super.initState();
     _discount.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _phone.dispose();
    _discount.dispose();
    _amountPaid.dispose();
    _description.dispose();
    super.dispose();
  }
// ... (lines 57-202 omitted, staying same)



  void _next() {
    if (_name.text.trim().isEmpty || _address.text.trim().isEmpty || _phone.text.trim().isEmpty) {
      return;
    }
    setState(() => _step = 2);
  }

  void _back() => setState(() => _step = 1);

  void _save() {
    final paid = double.tryParse(_amountPaid.text.trim()) ?? 0;
    final total = _finalTotal;
    final debt = (total - paid).clamp(0.0, double.infinity);
  
    Navigator.of(context).pop(
      NewCustomerResult(
        name: _name.text.trim(),
        address: _address.text.trim(),
        phone: _phone.text.trim(),
        initialDebt: debt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isStep1 = _step == 1;
    final primaryText = isDark ? Colors.white : const Color(0xFF0B1220);
    final secondaryText = isDark ? Colors.white70 : Colors.black54;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                   Expanded(
                    child: Text(
                      'New Customer',
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: secondaryText),
                  ),
                ],
              ),

              verticalSpace(8),
              _StepHeader(step: _step, isDark: isDark),
              verticalSpace(14),

              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: isStep1 
                    ? _buildCustomerStep(isDark, primaryText) 
                    : _buildPaymentStep(isDark, primaryText, secondaryText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
        borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2F6BFF), width: 2),
      ),
    );
  }


  Widget _buildCustomerStep(bool isDark, Color primaryText) {
    return _FormCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Label('Name', isDark: isDark),
          TextField(
            controller: _name,
            style: TextStyle(color: primaryText),
            decoration: _fieldDecoration('', isDark),
          ),
          verticalSpace(14),

          _Label('Address', isDark: isDark),
          TextField(
            controller: _address,
            style: TextStyle(color: primaryText),
            decoration: _fieldDecoration('', isDark),
          ),
          verticalSpace(14),

          _Label('Phone', isDark: isDark),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: primaryText),
            decoration: _fieldDecoration('', isDark),
          ),
          verticalSpace(16),

          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF38B24A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                ),
                child: const Text(
                  'Next →',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep(bool isDark, Color primaryText, Color secondaryText) {
    final discount = int.tryParse(_discount.text.trim()) ?? 0;
    const subtotal = 0;
    const finalTotal = 0;

    return _FormCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: _save,
                child: Text(
                  'Skip Payment',
                  style: TextStyle(
                    color: secondaryText,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(10),

          _Label('Select Products', isDark: isDark),
          _DropdownField(
            value: _selectedProduct,
            items: const ['Choose product', 'Amarya Foam', 'Vital Foam'],
            onChanged: (v) => setState(() => _selectedProduct = v),
            isDark: isDark,
            textColor: primaryText,
            iconColor: secondaryText,
          ),
          verticalSpace(14),

          _Label('Discount', isDark: isDark),
          TextField(
            controller: _discount,
            keyboardType: TextInputType.number,
            style: TextStyle(color: primaryText),
            decoration: _fieldDecoration('0', isDark),
          ),
          verticalSpace(14),

          _Label('Amount Paid', isDark: isDark),
          TextField(
            controller: _amountPaid,
            keyboardType: TextInputType.number,
            style: TextStyle(color: primaryText),
            decoration: _fieldDecoration('', isDark),
          ),
          verticalSpace(14),

          _Label('Payment Type', isDark: isDark),
          _DropdownField(
            value: _paymentType,
            items: const ['Select type', 'Cash', 'Transfer', 'POS'],
            onChanged: (v) => setState(() => _paymentType = v),
            isDark: isDark,
            textColor: primaryText,
            iconColor: secondaryText,
          ),
          verticalSpace(14),

          _Label('Description', isDark: isDark),
          TextField(
            controller: _description,
            maxLines: 3,
            style: TextStyle(color: primaryText),
            decoration: _fieldDecoration('', isDark),
          ),

          verticalSpace(16),

          _SummaryLine(label: 'Subtotal:', value: '$subtotal', isDark: isDark),
          _SummaryLine(
            label: 'Discount:',
            value: '-${_formatMoney(discount)}',
            valueColor: const Color(0xFFE04B5A),
            isDark: isDark,
          ),
          _SummaryLine(label: 'Final Total:', value: '$finalTotal', isDark: isDark),

          verticalSpace(16),

          Row(
            children: [
              _OutlineButton(
                label: '← Back',
                onTap: _back,
              ),
              const Spacer(),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF38B24A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatMoney(int v) {
    final s = v.abs().toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      b.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) b.write(',');
    }
    return b.toString();
  }
}

class _StepHeader extends StatelessWidget {
  final int step;
  final bool isDark;
  
  const _StepHeader({required this.step, required this.isDark});

  @override
  Widget build(BuildContext context) {
    // Fill color for inactive steps
    final inactiveFill = isDark ? const Color(0xFF141E31) : Colors.grey.shade300;
    
    final t = (step == 1) ? 0.0 : 1.0;
    final leftFill = Color.lerp(inactiveFill, inactiveFill, t)!;
    final rightFill = Color.lerp(inactiveFill, inactiveFill, t)!;

    final leftActive = step == 1;
    final rightActive = step == 2;

    return Row(
      children: [
        _StepPill(
          number: '1',
          label: 'Customer',
          active: leftActive,
          fill: leftFill,
          isDark: isDark,
        ),
        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: isDark ? Colors.white12 : Colors.black12,
          ),
        ),
        _StepPill(
          number: '2',
          label: 'Payment',
          active: rightActive,
          fill: rightFill,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _StepPill extends StatelessWidget {
  final String number;
  final String label;
  final bool active;
  final Color fill;
  final bool isDark;

  const _StepPill({
    required this.number,
    required this.label,
    required this.active,
    required this.fill,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Active background: light opaque white in dark mode, dark blue in light mode? 
    // Actually simplicity:
    // Dark Mode: Active=White24, Inactive=DarkBlue
    // Light Mode: Active=Black12, Inactive=Grey300
    
    final bg = active 
        ? (isDark ? Colors.white24 : Colors.black12) 
        : fill;
        
    final text = active 
        ? (isDark ? Colors.white : Colors.black)
        : (isDark ? Colors.white70 : Colors.black54);

    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              color: text,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        horizontalSpace(10),
        Text(
          label,
          style: TextStyle(
            color: text,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _FormCard extends StatelessWidget {
  final Widget child;
  final bool isDark;
  
  const _FormCard({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
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
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final bool isDark;
  final Color textColor;
  final Color iconColor;

  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.isDark,
    required this.textColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        border: Border.all(color: isDark ? Colors.white24 : Colors.black12, width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: Theme.of(context).cardColor,
          icon: Icon(Icons.unfold_more, color: iconColor),
          style: TextStyle(color: textColor, fontSize: 16),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {
            if (v == null) return;
            onChanged(v);
          },
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isDark;

  const _SummaryLine({
    required this.label,
    required this.value,
    this.valueColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontWeight: FontWeight.w700),
          ),
          horizontalSpace(6),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? (isDark ? Colors.white70 : Colors.black87),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFFFC24A), width: 1.6),
          foregroundColor: const Color(0xFFFFC24A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}
