import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

class TimeChart extends StatelessWidget {
  const TimeChart({
    this.title,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  final String? title;

  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(
            height: 8,
          ),
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                color: Color(0xff827daa),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
          const Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 6.0),
              child: /*LineChart(
                sampleData1(context),
                swapAnimationDuration: const Duration(milliseconds: 250),
              )*/
                  SizedBox(),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
/*
  LineChartData sampleData1(BuildContext context) => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: context.themeColor(light: Colors.grey.shade300, dark: const Color(0xff37434d)),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: context.themeColor(light: Colors.grey.shade300, dark: const Color(0xff37434d)),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: titlesData1,
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(
              color: context.themeColor(light: Colors.grey.shade300, dark: const Color(0xff4e4965)),
              width: 1,
            ),
            left: BorderSide(
              color: context.themeColor(light: Colors.grey.shade300, dark: const Color(0xff4e4965)),
              width: 1,
            ),
            right: const BorderSide(color: Colors.transparent),
            top: const BorderSide(color: Colors.transparent),
          ),
        ),
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 20,
        maxY: 350,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: bottomTitles,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        leftTitles: leftTitles(
          getTitles: (value) {
            switch (value.toInt()) {
              case 10:
                return '\$10';
              case 50:
                return '\$20';
              case 100:
                return '\$100';
              case 300:
                return '\$300';
            }
            return '';
          },
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  SideTitles leftTitles({required GetTitleFunction getTitles}) => SideTitles(
        getTitles: getTitles,
        showTitles: true,
        margin: 8,
        interval: 1,
        reservedSize: 40,
        getTextStyles: (context, value) => const TextStyle(
//          color: Color(0xff75729e),
          fontSize: 14,
        ),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 22,
        margin: 10,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
          //        color: Color(0xff72719b),
          fontSize: 14,
        ),
        getTitles: (value) {
          return value.toInt().toString();
        },
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
//        colors: [const Color(0xff4af699)],
        colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!,
          ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!,
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: true, colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!.withOpacity(0.1),
          ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!.withOpacity(0.1),
        ]),
        spots: const [
          FlSpot(1, 100),
          FlSpot(3, 100.5),
          FlSpot(5, 100.4),
          FlSpot(7, 300.4),
          FlSpot(10, 200),
          FlSpot(12, 200.2),
          FlSpot(13, 100.8),
        ],
      );*/
}

List<Color> gradientColors = [
  const Color(0xff23b6e6),
  const Color(0xff02d39a),
];
