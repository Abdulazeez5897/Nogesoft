import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nogesoft/core/data/models/purchase.dart';
import 'package:nogesoft/core/utils/currency_formatter.dart';
import 'package:intl/intl.dart';

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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111C2E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
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
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'View all',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (transactions.isEmpty)
             Padding(
               padding: const EdgeInsets.all(20),
               child: Text(
                 "No recent transactions", 
                 style: GoogleFonts.redHatDisplay(color: Colors.white54),
               ),
             )
          else
            ...transactions.map((txn) => _TxnCard(purchase: txn)).toList(),
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
    final name = purchase.supplier.name.isNotEmpty 
        ? purchase.supplier.name 
        : (purchase.items.isNotEmpty ? purchase.items.first.product.name : "Unknown");
        
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24, width: 1),
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
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _fmtDate(purchase.date),
                  style: GoogleFonts.redHatDisplay(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E2A1B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    purchase.status, 
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
          const SizedBox(width: 10),
          Text(
            CurrencyFormatter.formatNaira(purchase.totalAmount.toDouble()),
            style: GoogleFonts.redHatDisplay(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
