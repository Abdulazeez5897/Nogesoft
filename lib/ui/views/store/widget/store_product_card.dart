import 'package:flutter/material.dart';
import '../../../../core/data/models/product.dart';
import 'package:intl/intl.dart';
import 'package:nogesoft/ui/common/ui_helpers.dart';

class StoreProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StoreProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatNaira(double value) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return '₦${formatter.format(value)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.26 : 0.05),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            product.name,
            style: TextStyle(
              color: theme.textTheme.titleLarge?.color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          verticalSpace(4),
          Text(
            product.category,
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.black54,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          verticalSpaceSmall,
          Text(
            _formatNaira(product.price),
            style: TextStyle(
              color: theme.textTheme.titleLarge?.color,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          verticalSpace(12),

          Row(
            children: [
              _OutlineActionButton(
                label: 'Edit',
                borderColor: const Color(0xFFFFC24A),
                textColor: const Color(0xFFFFC24A),
                onTap: onEdit,
              ),
              horizontalSpace(12),
              _OutlineActionButton(
                label: 'Delete',
                borderColor: const Color(0xFFE04B5A),
                textColor: const Color(0xFFE04B5A),
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  final String label;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _OutlineActionButton({
    required this.label,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 1.6),
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
