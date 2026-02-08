import 'package:flutter/material.dart';

import 'package:nogesoft/core/data/models/purchase.dart';
import 'package:nogesoft/ui/common/ui_helpers.dart';

class PurchaseCard extends StatelessWidget {
  final Purchase purchase;
  final String Function(int) money;
  final String Function(DateTime) date;

  const PurchaseCard({
    super.key,
    required this.purchase,
    required this.money,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Fallback logic if needed, or just use theme colors directly
    final primary = theme.textTheme.titleLarge?.color ?? (isDark ? Colors.white : const Color(0xFF0B1220));
    final muted = isDark ? Colors.white60 : Colors.black54;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      purchase.invoiceNumber,
                      style: TextStyle(
                        color: primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      purchase.supplier.name,
                      style: TextStyle(
                        color: muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    verticalSpace(6),
                    Text(
                      '${purchase.items.length} items',
                      style: TextStyle(
                        color: muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    money(purchase.totalAmount),
                    style: TextStyle(
                      color: primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  verticalSpace(4),
                  Text(
                    date(purchase.date),
                    style: TextStyle(
                      color: muted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          verticalSpace(12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Paid: ${money(purchase.amountPaid)} | Bal: ${money(purchase.totalAmount - purchase.amountPaid)}',
              style: TextStyle(
                color: muted,
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
