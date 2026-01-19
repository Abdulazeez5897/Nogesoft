import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardTopSelling extends StatelessWidget {
  const DashboardTopSelling({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Selling Products',
            style: GoogleFonts.redHatDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),

          const _TopSellRow(
            rank: '1',
            name: 'Vital Foam',
            sold: '12 sold',
            amount: '₦217,499',
          ),
          const SizedBox(height: 12),
          const _TopSellRow(
            rank: '2',
            name: 'Amarya Foam',
            sold: '6 sold',
            amount: '₦6,750',
          ),
        ],
      ),
    );
  }
}

class _TopSellRow extends StatelessWidget {
  final String rank;
  final String name;
  final String sold;
  final String amount;

  const _TopSellRow({
    required this.rank,
    required this.name,
    required this.sold,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 22,
          child: Text(
            rank,
            style: GoogleFonts.redHatDisplay(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 6),
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
              const SizedBox(height: 2),
              Text(
                sold,
                style: GoogleFonts.redHatDisplay(
                  color: Colors.white60,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: GoogleFonts.redHatDisplay(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
