import 'package:flutter/material.dart';

import '../model/report_models.dart';

class ReportMetricCard extends StatelessWidget {
  final ReportMetric metric;

  const ReportMetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF101A2B) : const Color(0xFFEEF2F6);
    final labelColor = isDark ? Colors.white70 : Colors.black54;

    final valueStyle = TextStyle(
      color: _valueColor(isDark),
      fontSize: 20,
      fontWeight: FontWeight.w900,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.10),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(metric.label, style: TextStyle(color: labelColor, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
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
