import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardKpiGrid extends StatelessWidget {
  final VoidCallback onLowStockTap;
  const DashboardKpiGrid({super.key, required this.onLowStockTap});

  static const String naira = '\u20A6';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: _KpiCard(
                title: "Today's Sales",
                value: "${DashboardKpiGrid.naira}0",
                valueColor: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _KpiCard(
                title: "Today's Profit",
                value: "${DashboardKpiGrid.naira}0",
                valueColor: Color(0xFF38B24A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(
              child: _KpiCard(
                title: "This Month",
                value: "${DashboardKpiGrid.naira}224,239",
                valueColor: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _KpiCard(
                title: "Customers",
                value: "44",
                valueColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(
              child: _KpiCard(
                title: "Transactions",
                value: "16",
                valueColor: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _KpiCard(
                title: "Unpaid Balance",
                value: "${DashboardKpiGrid.naira}189,989",
                valueColor: Color(0xFFFF7A18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _LowStockCard(
                onTap: onLowStockTap,
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
          const SizedBox(height: 8),
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
  const _LowStockCard({required this.onTap});

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
                '0',
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
