import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../models/dashboard_metrics.dart';
import '../../../../utils/formatters.dart';

/// Revenue-per-day line chart for the overview screen.
class SalesChart extends StatelessWidget {
  const SalesChart({super.key, required this.series});

  final List<DailySales> series;

  @override
  Widget build(BuildContext context) {
    if (series.isEmpty) return const SizedBox.shrink();

    final maxRevenue = series
        .map((day) => day.revenue)
        .fold<double>(0, (max, value) => value > max ? value : max);
    // A flat zero series would collapse the chart, so keep a minimum ceiling.
    final maxY = maxRevenue <= 0 ? 100.0 : maxRevenue * 1.25;

    // With many points, only every n-th date label fits.
    final labelStep = (series.length / 6).ceil().clamp(1, series.length);

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Theme.of(context).dividerColor,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 52,
              interval: maxY / 4,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(right: defaultPadding / 4),
                child: Text(
                  formatCompactPrice(value),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= series.length) {
                  return const SizedBox.shrink();
                }
                if (index % labelStep != 0) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(top: defaultPadding / 4),
                  child: Text(
                    formatShortDate(series[index].day),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots.map((spot) {
              final day = series[spot.x.toInt()];
              return LineTooltipItem(
                "${formatShortDate(day.day)}\n${formatPrice(day.revenue)}",
                const TextStyle(color: Colors.white, fontSize: 12),
              );
            }).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < series.length; i++)
                FlSpot(i.toDouble(), series[i].revenue),
            ],
            isCurved: true,
            curveSmoothness: 0.25,
            barWidth: 3,
            color: primaryColor,
            dotData: FlDotData(show: series.length <= 14),
            belowBarData: BarAreaData(
              show: true,
              color: primaryColor.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}
