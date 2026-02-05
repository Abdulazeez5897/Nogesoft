import 'package:flutter/material.dart';

import '../model/report_models.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';

class ReportMetricCard extends StatelessWidget {
  final ReportMetric metric;
  const ReportMetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white70 : const Color(0xFF555F71);
    final valueStyle = TextStyle(
      color: _valueColor(isDark),
      fontSize: 26,
      fontWeight: FontWeight.w900,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101A2B) : const Color(0xFFEEF2F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(metric.label, style: TextStyle(color: labelColor, fontWeight: FontWeight.w700)),
          verticalSpace(8),
          Text(metric.value, style: valueStyle),
        ],
      ),
    );
  }

  Color _valueColor(bool isDark) {
    switch (metric.type) {
      case ReportMetricType.remaining:
        return const Color(0xFFFFC24A);
      case ReportMetricType.revenue:
        return const Color(0xFF2F6BFF);
      case ReportMetricType.cogs:
        return const Color(0xFFE04B5A);
      case ReportMetricType.profit:
        return const Color(0xFF52E08A);
      default:
        return isDark ? Colors.white : const Color(0xFF0B1220);
    }
  }
}
