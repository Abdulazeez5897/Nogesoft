import 'package:flutter/foundation.dart';

enum ReportMetricType {
  bought,
  sold,
  remaining,
  avgUnitCost,
  revenue,
  cogs,
  profit,
  amountPaid,
}

@immutable
class ReportMetric {
  final ReportMetricType type;
  final String label;
  final String value;

  const ReportMetric({
    required this.type,
    required this.label,
    required this.value,
  });
}

@immutable
class ProductBreakdownItem {
  final String name;
  final int bought;
  final int sold;
  final int remaining;
  final int revenue;
  final int cogs;
  final int profit;
  final double progress; // 0..1

  const ProductBreakdownItem({
    required this.name,
    required this.bought,
    required this.sold,
    required this.remaining,
    required this.revenue,
    required this.cogs,
    required this.profit,
    required this.progress,
  });
}
