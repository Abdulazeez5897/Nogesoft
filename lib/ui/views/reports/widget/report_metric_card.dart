import 'package:flutter/material.dart';

import '../model/report_models.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';

class ReportMetricCard extends StatelessWidget {
  final ReportMetric metric;
  const ReportMetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white70 : const Color(0xFF555F71);
    final valueStyle = TextStyle(
      color: _valueColor(isDark, theme),
      fontSize: 26,
      fontWeight: FontWeight.w900,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
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

  Color _valueColor(bool isDark, ThemeData theme) {
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
        return theme.textTheme.titleLarge?.color ?? (isDark ? Colors.white : const Color(0xFF0B1220));
    }
  }
}
