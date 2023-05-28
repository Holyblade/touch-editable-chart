/////~Example 3//////////

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExampleThree extends StatelessWidget {
  const ExampleThree({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touch Editable Chart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Touch Editable Chart')),
        ),
        body: const EditableLineChart(),
      ),
    );
  }
}

class EditableLineChart extends StatefulWidget {
  const EditableLineChart({super.key});

  @override
  EditableLineChartState createState() => EditableLineChartState();
}

class EditableLineChartState extends State<EditableLineChart> {
  final double chartWidth = 300;
  final double chartHeight = 200;

  List<FlSpot> spots = [
    const FlSpot(0, 5),
    const FlSpot(1, 2),
    const FlSpot(2, 5),
    const FlSpot(3, 4),
    const FlSpot(4, 3),
    const FlSpot(5, 6),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            final xValue = details.localPosition.dx;
            final yValue = details.localPosition.dy;

            final x = xValue * (spots.length - 1) / chartWidth;
            final y = (chartHeight - yValue) * (7 / chartHeight);

            final nearestSpot = _findNearestSpot(x, y);
            if (nearestSpot != null) {
              spots = spots.map((spot) {
                if (spot.x == nearestSpot.x && spot.y == nearestSpot.y) {
                  return FlSpot(x, y);
                }
                return spot;
              }).toList();
            }
          });
        },
        child: SizedBox(
          width: chartWidth,
          height: chartHeight,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(enabled: true),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  color: Colors.green,
                ),
              ],
              minY: 0,
              maxY: 7,
            ),
          ),
        ),
      ),
    );
  }

  FlSpot? _findNearestSpot(double x, double y) {
    double minDistance = double.maxFinite;
    FlSpot? nearestSpot;

    for (final spot in spots) {
      final distance = (spot.x - x).abs() + (spot.y - y).abs();
      if (distance < minDistance) {
        minDistance = distance;
        nearestSpot = spot;
      }
    }

    return nearestSpot;
  }
}
