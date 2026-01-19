import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardRecentTransactions extends StatelessWidget {
  final VoidCallback onViewAll;
  const DashboardRecentTransactions({super.key, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            InkWell(
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

        const _TxnCard(
          name: 'Abdulazeez Usman',
          amount: '₦209,989',
          date: '1/18/26, 12:23 AM',
          tag: 'income',
        ),
        const _TxnCard(
          name: 'Umar',
          amount: '₦3,000',
          date: '1/17/26, 12:40 PM',
          tag: 'income',
        ),
        const _TxnCard(
          name: 'Mr Adam',
          amount: '₦750',
          date: '1/17/26, 12:18 PM',
          tag: 'income',
        ),
      ],
    );
  }
}

class _TxnCard extends StatelessWidget {
  final String name;
  final String amount;
  final String date;
  final String tag;

  const _TxnCard({
    required this.name,
    required this.amount,
    required this.date,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
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
                  date,
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
                    tag,
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
            amount,
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
