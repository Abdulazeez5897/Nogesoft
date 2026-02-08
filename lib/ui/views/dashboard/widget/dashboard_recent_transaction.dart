import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nogesoft/core/data/models/purchase.dart';
import 'package:nogesoft/core/utils/currency_formatter.dart';
import 'package:intl/intl.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';

class DashboardRecentTransactions extends StatelessWidget {
  final VoidCallback onViewAll;
  final List<Purchase> transactions;

  const DashboardRecentTransactions({
    super.key, 
    required this.onViewAll,
    this.transactions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Recent Transactions',
                style: GoogleFonts.redHatDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'View all',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(12),
          if (transactions.isEmpty)
             Padding(
               padding: const EdgeInsets.all(20),
               child: Text(
                 "No recent transactions", 
                 style: GoogleFonts.redHatDisplay(color: isDark ? Colors.white54 : Colors.black45),
               ),
             )
          else
            ...transactions.map((txn) => _TxnCard(purchase: txn)),
        ],
      ),
    );
  }
}

class _TxnCard extends StatelessWidget {
  final Purchase purchase;

  const _TxnCard({required this.purchase});

  String _fmtDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('M/d/yy, h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final name = purchase.supplier.name.isNotEmpty 
        ? purchase.supplier.name 
        : (purchase.items.isNotEmpty ? purchase.items.first.product.name : "Unknown");
        
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white24 : Colors.black12, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.redHatDisplay(
                    color: theme.textTheme.bodyMedium?.color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                verticalSpace(6),
                Text(
                  _fmtDate(purchase.date),
                  style: GoogleFonts.redHatDisplay(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: 13,
                  ),
                ),
                verticalSpaceSmall,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38B24A).withOpacity(0.15), // Light green background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    purchase.status == 'Completed' ? 'Income' : purchase.status,
                    style: GoogleFonts.redHatDisplay(
                      color: const Color(0xFF38B24A),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          horizontalSpaceSmall,
          Text(
            CurrencyFormatter.formatNaira(purchase.totalAmount.toDouble()),
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
