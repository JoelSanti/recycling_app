import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget buildWeeklyFrequency(Map<String, int> dailyCounts) {
  List<BarChartGroupData> barGroups = [];
  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  for (int i = 0; i < daysOfWeek.length; i++) {
    barGroups.add(
      BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: (dailyCounts[daysOfWeek[i]] ?? 0)
                .toDouble(), // Provide a default value of 0 if the count is null
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  double maxY =
      (dailyCounts.values.reduce((curr, next) => curr > next ? curr : next) + 2)
          .toDouble();

  return BarChart(
    BarChartData(
      maxY: maxY,
      barGroups: barGroups,
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 22,
            getTitlesWidget: (value, meta) {
              return Text(value.toInt().toString());
            },
          ),
        ),
        bottomTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
      ),
    ),
  );
}

Widget getTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'L';
      break;
    case 1:
      text = 'M';
      break;
    case 2:
      text = 'M';
      break;
    case 3:
      text = 'J';
      break;
    case 4:
      text = 'V';
      break;
    case 5:
      text = 'S';
      break;
    case 6:
      text = 'D';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4,
    child: Text(text, style: style),
  );
}
