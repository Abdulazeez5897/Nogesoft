import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nogesoft/core/utils/currency_formatter.dart';

import 'package:nogesoft/core/data/models/dashboard_stats.dart';
import 'package:nogesoft/ui/common/ui_helpers.dart';

class DashboardKpiGrid extends StatelessWidget {
  final VoidCallback onLowStockTap;
  final DashboardStats? stats;

  const DashboardKpiGrid({
    super.key, 
    required this.onLowStockTap,
    this.stats,
  });

  static const String naira = '\u20A6';

  @override
  Widget build(BuildContext context) {
    // Show zeroes if stats is null (loading/error)
    final s = stats ?? const DashboardStats();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                title: "Total Revenue", // Renamed from Today for now
                value: CurrencyFormatter.formatNaira(s.totalRevenue),
                valueColor: Colors.white,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: _KpiCard(
                title: "Profit", // Placeholder
                value: CurrencyFormatter.formatNaira(0),
                valueColor: const Color(0xFF38B24A),
              ),
            ),
          ],
        ),
        verticalSpace(12),
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                title: "This Month",
                value: CurrencyFormatter.formatNaira(s.totalRevenue), // Mapping total for now
                valueColor: Colors.white,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: _KpiCard(
                title: "Customers",
                value: "${s.totalCustomers}",
                valueColor: Colors.white,
              ),
            ),
          ],
        ),
        verticalSpace(12),
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                title: "Transactions",
                value: "${s.totalSales}",
                valueColor: Colors.white,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: _KpiCard(
                title: "Unpaid Balance",
                value: CurrencyFormatter.formatNaira(0),
                valueColor: const Color(0xFFFF7A18),
              ),
            ),
          ],
        ),
        verticalSpace(12),
        Row(
          children: [
            Expanded(
              child: _LowStockCard(
                onTap: onLowStockTap,
                count: s.lowStockItems,
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111C2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.redHatDisplay(
              color: Colors.white60,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          verticalSpace(8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.redHatDisplay(
              color: valueColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _LowStockCard extends StatelessWidget {
  final VoidCallback onTap;
  final int count;
  const _LowStockCard({required this.onTap, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111C2E),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Low Stock Items',
            style: GoogleFonts.redHatDisplay(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                '$count',
                style: GoogleFonts.redHatDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFF3B30),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  'View Items',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 13,
                    color: Colors.white70,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
