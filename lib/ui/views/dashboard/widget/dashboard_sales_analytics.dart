import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardSalesAnalytics extends StatelessWidget {
  final String selectedRange;
  final List<String> ranges;
  final ValueChanged<String> onRangeChanged;

  const DashboardSalesAnalytics({
    super.key,
    required this.selectedRange,
    required this.ranges,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Prevent DropdownButton crash if selectedRange isn't inside ranges
    final safeSelected = ranges.contains(selectedRange)
        ? selectedRange
        : (ranges.isNotEmpty ? ranges.first : '');

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
            'Sales Analytics',
            style: GoogleFonts.redHatDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          /// Dropdown (bordered like recording)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white38, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: safeSelected.isEmpty ? null : safeSelected,
                isExpanded: true,
                dropdownColor: const Color(0xFF0C1524),
                iconEnabledColor: Colors.white70,
                style: const TextStyle(color: Colors.white),
                items: ranges
                    .map(
                      (e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e,
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
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

          const SizedBox(height: 14),

          SizedBox(
            height: 190,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 220000,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(color: Colors.white24),
                    bottom: BorderSide(color: Colors.white24),
                    right: BorderSide(color: Colors.transparent),
                    top: BorderSide(color: Colors.transparent),
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      getTitlesWidget: (value, meta) {
                        if (value % 50000 != 0) return const SizedBox.shrink();
                        final label = value == 0 ? '0' : '${(value / 1000).round()},000';
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            label,
                            style: const TextStyle(color: Colors.white54, fontSize: 11),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final style = const TextStyle(color: Colors.white54, fontSize: 11);
                        switch (value.toInt()) {
                          case 0:
                            return Text('Wed 14', style: style);
                          case 1:
                            return Text('Thu 15', style: style);
                          case 2:
                            return Text('Fri 16', style: style);
                          case 3:
                            return Text('Sat 17', style: style);
                          default:
                            return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 12000),
                      FlSpot(1, 0),
                      FlSpot(2, 65000),
                      FlSpot(3, 210000),
                    ],
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
    );
  }
}
