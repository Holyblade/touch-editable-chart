import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExampleFour extends StatelessWidget {
  const ExampleFour({super.key});

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
  List<List<FlSpot>> series = [
    [
      const FlSpot(0, 5),
      const FlSpot(1, 2),
      const FlSpot(2, 5),
    ],
    [
      const FlSpot(0, 3),
      const FlSpot(1, 4),
      const FlSpot(2, 2),
    ],
    [
      const FlSpot(0, 1),
      const FlSpot(1, 5),
      const FlSpot(2, 3),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final chartWidth = screenSize.width;
    final chartHeight = screenSize.height;

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          final xValue = details.localPosition.dx;
          final yValue = details.localPosition.dy;

          final x = xValue * (series[0].length - 1) / chartWidth;
          final y = (chartHeight - yValue) * (7 / chartHeight);

          for (int i = 0; i < series.length; i++) {
            final nearestSpot = _findNearestSpot(series[i], x, y);
            if (nearestSpot != null) {
              final index = series[i].indexOf(nearestSpot);

              series[i][index] = FlSpot(x, y);
            }
          }
        });
      },
      child: SizedBox(
        width: chartWidth,
        height: chartHeight,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(enabled: true),
            lineBarsData: series.map((spots) {
              return LineChartBarData(
                spots: spots,
                color: Colors.green,
              );
            }).toList(),
            minY: 0,
            maxY: 7,
          ),
        ),
      ),
    );
  }

  FlSpot? _findNearestSpot(List<FlSpot> spots, double x, double y) {
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
