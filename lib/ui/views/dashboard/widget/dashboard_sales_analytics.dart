import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';

class DashboardSalesAnalytics extends StatelessWidget {
  final String selectedRange;
  final List<String> ranges;
  final ValueChanged<String> onRangeChanged;
  final List<FlSpot> spots;
  final List<String> bottomTitles;

  const DashboardSalesAnalytics({
    super.key,
    required this.selectedRange,
    required this.ranges,
    required this.onRangeChanged,
    this.spots = const [FlSpot(0, 0)],
    this.bottomTitles = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      type: MaterialType.transparency, // ✅ fixes "No Material widget found"
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
              blurRadius: 18,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Analytics',
              style: GoogleFonts.redHatDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            verticalSpace(12),

            // Dropdown styled like recording (bordered field)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? Colors.white38 : Colors.black26, width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedRange,
                  isExpanded: true,
                  dropdownColor: theme.cardColor,
                  iconEnabledColor: isDark ? Colors.white70 : Colors.black54,
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  items: ranges
                      .map(
                        (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(
                        e,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) onRangeChanged(v);
                  },
                ),
              ),
            ),

            verticalSpace(14),

            SizedBox(
              height: 190,
              child: LineChart(
                  LineChartData(
                    clipData: const FlClipData.all(),
                    minY: 0,
                    // maxY: 220000, // Removed hardcoded limit for dynamic scaling
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
                        bottom: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
                        right: const BorderSide(color: Colors.transparent),
                        top: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        getTitlesWidget: (value, meta) {
                          if (value % 50000 != 0) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              value == 0 ? '0' : '${(value / 1000).round()},000',
                              style: TextStyle(
                                color: isDark ? Colors.white54 : Colors.black54,
                                fontSize: 11,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1, // Ensure we step 1 by 1
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < bottomTitles.length) {
                             return Padding(
                               padding: const EdgeInsets.only(top: 8.0),
                               child: Text(
                                 bottomTitles[index],
                                 style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 11),
                               ),
                             );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      barWidth: 3,
                      color: const Color(0xFF3B82F6),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: const Color(0xFF3B82F6),
                            strokeWidth: 0,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
