import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nogesoft/core/data/models/product.dart';
import 'package:nogesoft/core/utils/currency_formatter.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';

class DashboardTopSelling extends StatelessWidget {
  final List<Product> products;

  const DashboardTopSelling({
    super.key,
    this.products = const [],
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
          verticalSpace(14),

          if (products.isEmpty)
            Text(
              "No sales data yet",
              style: GoogleFonts.redHatDisplay(color: Colors.white54),
            )
          else
            ...products.asMap().entries.map((e) {
              final index = e.key;
              final product = e.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _TopSellRow(
                  rank: '${index + 1}',
                  name: product.name,
                  sold: '${product.stockQuantity} sold', // Using stock as simplified 'sold' for now or need a better metric
                  amount: CurrencyFormatter.formatNaira(product.price),
                ),
              );
            }),
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
        horizontalSpace(6),
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
              verticalSpace(2),
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
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
