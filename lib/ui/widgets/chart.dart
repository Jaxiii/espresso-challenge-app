import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CoinChart extends StatefulWidget {
  final List<List<dynamic>> priceData;

  const CoinChart({super.key, required this.priceData});

  @override
  State<CoinChart> createState() => _CoinChartState();
}

class _CoinChartState extends State<CoinChart> {
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];

  bool showAvg = false;
  double minY = 0;
  double maxY = 0;
  double midY = 0;

  @override
  void initState() {
    super.initState();
    final prices = widget.priceData.map((e) => e[1] as double);
    minY = roundDouble(prices.reduce(math.min));
    maxY = roundDouble(prices.reduce(math.max));
    midY = (minY + maxY) / 2;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.black,
      height: value == minY
          ? 0.1
          : value == maxY
              ? 2.5
              : 1,
    );

    if (value == minY ||
        value.toStringAsFixed(0) == midY.toStringAsFixed(0) ||
        value == maxY) {
      final String text = value > 100
          ? value.toStringAsFixed(0)
          : roundDouble(value).toString();
      return Text(text, style: style);
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          mainData(),
        ),
      ),
    );
  }

  double roundDouble(double value) {
    if (value == 0) return 0;

    int places;
    if (value >= 1) {
      places = 2;
    }
    if (value < 1 && value >= 0.1) {
      places = 3;
    } else {
      String valueStr = value.toStringAsExponential();
      int indexOfE = valueStr.indexOf('e');
      int exponent = int.parse(valueStr.substring(indexOfE + 1));
      places = -exponent + 3;
    }

    num mod = math.pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  List<FlSpot> getSpots() {
    double maxX = 0;
    return widget.priceData.map((e) {
      double x = (e[0] - widget.priceData.first[0]) / (1000 * 60 * 60 * 24);
      double y = e[1];
      maxX = x > maxX ? x : maxX;
      return FlSpot(x, roundDouble(y));
    }).toList();
  }

  LineChartData mainData() {
    List<FlSpot> spots = getSpots();

    return LineChartData(
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: true,
        horizontalInterval: (maxY - minY) / 5 > 0 ? (maxY - minY) / 5 : 1,
        verticalInterval: 1,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      minX: spots.first.x,
      maxX: spots.last.x,
      minY: spots.map((spot) => spot.y).reduce(math.min),
      maxY: spots.map((spot) => spot.y).reduce(math.max),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 1,
          dotData: const FlDotData(show: false),
        ),
      ],
    );
  }
}
