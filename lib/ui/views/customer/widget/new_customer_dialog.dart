import 'dart:ui' show lerpDouble;

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
    final isStep1 = _step == 1;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      backgroundColor: const Color(0xFF0E1626),
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
                  const Expanded(
                    child: Text(
                      'New Customer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              _StepHeader(step: _step),
              const SizedBox(height: 14),

              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: isStep1 ? _buildCustomerStep() : _buildPaymentStep(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerStep() {
    return _FormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Label('Name'),
          TextField(
            controller: _name,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(''),
          ),
          const SizedBox(height: 14),

          const _Label('Address'),
          TextField(
            controller: _address,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(''),
          ),
          const SizedBox(height: 14),

          const _Label('Phone'),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(''),
          ),
          const SizedBox(height: 16),

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

  Widget _buildPaymentStep() {
    final discount = int.tryParse(_discount.text.trim()) ?? 0;
    // In video, subtotal/final total are shown but not derived from real cart.
    const subtotal = 0;
    final finalTotal = 0; // match video: stays 0 while discount shows -2,000 etc.

    return _FormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: _save,
                child: const Text(
                  'Skip Payment',
                  style: TextStyle(
                    color: Colors.white70,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          const _Label('Select Products'),
          _DropdownField(
            value: _selectedProduct,
            items: const ['Choose product', 'Amarya Foam', 'Vital Foam'],
            onChanged: (v) => setState(() => _selectedProduct = v),
          ),
          const SizedBox(height: 14),

          const _Label('Discount'),
          TextField(
            controller: _discount,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('0'),
          ),
          const SizedBox(height: 14),

          const _Label('Amount Paid'),
          TextField(
            controller: _amountPaid,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(''),
          ),
          const SizedBox(height: 14),

          const _Label('Payment Type'),
          _DropdownField(
            value: _paymentType,
            items: const ['Select type', 'Cash', 'Transfer', 'POS'],
            onChanged: (v) => setState(() => _paymentType = v),
          ),
          const SizedBox(height: 14),

          const _Label('Description'),
          TextField(
            controller: _description,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(''),
          ),

          const SizedBox(height: 16),

          _SummaryLine(label: 'Subtotal:', value: '$subtotal'),
          _SummaryLine(
            label: 'Discount:',
            value: '-${_formatMoney(discount)}',
            valueColor: const Color(0xFFE04B5A),
          ),
          _SummaryLine(label: 'Final Total:', value: '$finalTotal'),

          const SizedBox(height: 16),

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
  const _StepHeader({required this.step});

  @override
  Widget build(BuildContext context) {
    final t = (step == 1) ? 0.0 : 1.0;
    final leftFill = Color.lerp(const Color(0xFF141E31), const Color(0xFF141E31), t)!;
    final rightFill = Color.lerp(const Color(0xFF141E31), const Color(0xFF141E31), t)!;

    final leftActive = step == 1;
    final rightActive = step == 2;

    return Row(
      children: [
        _StepPill(
          number: '1',
          label: 'Customer',
          active: leftActive,
          fill: leftFill,
        ),
        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white12,
          ),
        ),
        _StepPill(
          number: '2',
          label: 'Payment',
          active: rightActive,
          fill: rightFill,
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

  const _StepPill({
    required this.number,
    required this.label,
    required this.active,
    required this.fill,
  });

  @override
  Widget build(BuildContext context) {
    final bg = active ? Colors.white24 : fill;
    final text = active ? Colors.white : Colors.white70;

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
              color: active ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 10),
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
  const _FormCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF101A2B),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 14,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
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
        style: const TextStyle(
          color: Colors.white70,
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

  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF0E1626),
          icon: const Icon(Icons.unfold_more, color: Colors.white54),
          style: const TextStyle(color: Colors.white, fontSize: 16),
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

  const _SummaryLine({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white70,
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
