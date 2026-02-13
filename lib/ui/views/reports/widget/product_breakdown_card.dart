import 'package:flutter/material.dart';

import '../model/report_models.dart';


import 'package:nogesoft/ui/common/ui_helpers.dart';

class ProductBreakdownCard extends StatelessWidget {
  final String query;
  final ValueChanged<String> onQueryChanged;
  final bool isDark;
  final ProductBreakdownItem? item;

  const ProductBreakdownCard({
    super.key,
    required this.query,
    required this.onQueryChanged,
    required this.isDark,
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final textPrimary = theme.textTheme.titleLarge?.color ?? (isDark ? Colors.white : const Color(0xFF0B1220));
    final textMuted = isDark ? Colors.white54 : const Color(0xFF555F71);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Breakdown',
              style: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w900)),
          verticalSpace(12),

          _SearchField(
            hint: 'Search product...',
            value: query,
            onChanged: onQueryChanged,
            isDark: isDark,
          ),

          verticalSpace(14),

          if (item == null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Text(
                  'No product found',
                  style: TextStyle(color: textMuted, fontWeight: FontWeight.w800),
                ),
              ),
            )
          else ...[
            _KVRow(label: 'Product', value: item!.name, labelColor: textMuted, valueColor: textPrimary),
            _KVRow(label: 'Bought', value: '${item!.bought}', labelColor: textMuted, valueColor: textPrimary),
            _KVRow(label: 'Sold', value: '${item!.sold}', labelColor: textMuted, valueColor: textPrimary),
            _KVRow(label: 'Remaining', value: '${item!.remaining}', labelColor: textMuted, valueColor: textPrimary),
            _KVRow(
              label: 'Revenue',
              value: _money(item!.revenue),
              labelColor: textMuted,
              valueColor: textPrimary,
            ),
            _KVRow(
              label: 'COGS',
              value: _money(item!.cogs),
              labelColor: textMuted,
              valueColor: textPrimary,
            ),
            _KVRow(
              label: 'Profit',
              value: _money(item!.profit),
              labelColor: textMuted,
              valueColor: const Color(0xFF52E08A),
            ),
            verticalSpace(12),
            Row(
// ...
              children: [
                SizedBox(
                  width: 92,
                  child: Text('Progress', style: TextStyle(color: textMuted, fontWeight: FontWeight.w700)),
                ),
                Expanded(child: _ProgressBar(value: item!.progress)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _money(int value) {
    final s = value.abs().toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      b.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) b.write(',');
    }
    return '₦$b';
  }
}

class _KVRow extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;

  const _KVRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(label, style: TextStyle(color: labelColor, fontWeight: FontWeight.w700)),
          ),
          const Spacer(),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double value; // 0..1
  const _ProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 10,
        color: Colors.white12,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: v,
            child: Container(color: const Color(0xFF52E08A)),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final String hint;
  final String value;
  final ValueChanged<String> onChanged;
  final bool isDark;

  const _SearchField({
    required this.hint,
    required this.value,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0B1220), fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38, fontWeight: FontWeight.w700),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12, width: 1.6),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF38B24A), width: 1.6),
          ),
        ),
      ),
    );
  }
}
