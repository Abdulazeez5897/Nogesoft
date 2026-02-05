import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';

class SalesChart extends StatelessWidget {
// ...
          const Text(
            'Weekly Sales',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          verticalSpace(16),
          Expanded(
// ...
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: weeklySales.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value);
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xFF38B24A),
                    barWidth: 4,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF38B24A).withOpacity(0.2),
                    ),
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
