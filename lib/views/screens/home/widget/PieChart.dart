import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget buildPieChart(Map<String, int> data) {
  List<PieChartSectionData> sections = [];
  List<Widget> legends = [];

  data.forEach((key, value) {
    const isTouched = false;
    final double fontSize = isTouched ? 25 : 16;
    final double radius = isTouched ? 60 : 50;
    Color color;

    switch (key) {
      case 'residuos_aprovechables':
        color = Colors.white;
        break;
      case 'residuos_organicos_aprovechables':
        color = Colors.green;
        break;
      case 'residuos_no_aprovechables':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    sections.add(
      PieChartSectionData(
        color: color,
        value: value.toDouble(),
        title: '$value',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffbbdab5)),
      ),
    );

    legends.add(buildLegend(key, color));
  });

  return Column(
    children: <Widget>[
      Container(
        height: 195, // Ajusta este valor según tus necesidades
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, PieTouchResponse? response) {}),
            borderData: FlBorderData(show: false),
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            sections: sections,
          ),
        ),
      ),
      ...legends,
    ],
  );
}

Widget buildLegend(String key, Color color) {
  Map<String, String> labels = {
  'residuos_aprovechables': 'Residuos \nAprovechables',
  'residuos_organicos_aprovechables': 'Residuos Orgánicos \nAprovechables',
  'residuos_no_aprovechables': 'Residuos No \nAprovechables',
};
  String title = labels[key] ?? key;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5), // Ajusta este valor según tus necesidades
    child: Row(
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            border: Border.all(width: 1, color: Colors.black), // Ajusta el color y el ancho del borde según tus necesidades
          ),
          child: SizedBox(
            width: 15,
            height: 15,
          ),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14, // Ajusta este valor según tus necesidades
          ),
        )
      ],
    ),
  );
}