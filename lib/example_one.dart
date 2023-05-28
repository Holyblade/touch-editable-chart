import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EditableLineChart extends StatefulWidget {
  const EditableLineChart({Key? key}) : super(key: key);

  @override
  EditableLineChartState createState() => EditableLineChartState();
}

class EditableLineChartState extends State<EditableLineChart> {
  List<FlSpot> spots = [
    const FlSpot(0, 5),
    const FlSpot(1, 2),
    const FlSpot(2, 5),
    const FlSpot(3, 4),
    const FlSpot(4, 3),
    const FlSpot(5, 6),
  ];

  int? selectedSpotIndex;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final chartWidth = screenSize.width;
    final chartHeight = screenSize.height;

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          if (selectedSpotIndex != null) {
            final xValue = details.localPosition.dx;
            final yValue = details.localPosition.dy;

            final x = xValue * 12 / chartWidth;
            final y = (chartHeight - yValue) * 240 / chartHeight;

            if (y >= 0 && y <= 240) {
              final updatedSpots = List<FlSpot>.from(spots);
              updatedSpots[selectedSpotIndex!] = FlSpot(x, y);

              if (selectedSpotIndex! > 0 &&
                  x < spots[selectedSpotIndex! - 1].x) {
                for (int i = selectedSpotIndex! - 1; i >= 0; i--) {
                  if (x < updatedSpots[i].x) {
                    final prevX = updatedSpots[i].x;
                    updatedSpots[i] =
                        FlSpot(x > 0 ? x - 0.01 : 0, updatedSpots[i].y);
                    if (i > 0 && prevX < updatedSpots[i - 1].x) {
                      updatedSpots[i - 1] =
                          FlSpot(prevX, updatedSpots[i - 1].y);
                    }
                  } else {
                    break;
                  }
                }
              }

              if (selectedSpotIndex! < spots.length - 1 &&
                  x > spots[selectedSpotIndex! + 1].x) {
                for (int i = selectedSpotIndex! + 1; i < spots.length; i++) {
                  if (x > updatedSpots[i].x) {
                    final prevX = updatedSpots[i].x;
                    updatedSpots[i] =
                        FlSpot(x < 12 ? x + 0.01 : 12, updatedSpots[i].y);
                    if (i < updatedSpots.length - 1 &&
                        prevX > updatedSpots[i + 1].x) {
                      updatedSpots[i + 1] =
                          FlSpot(prevX, updatedSpots[i + 1].y);
                    }
                  } else {
                    break;
                  }
                }
              }

              spots = updatedSpots;
            }
          }
        });
      },
      onTapDown: (details) {
        final xValue = details.localPosition.dx;
        final yValue = details.localPosition.dy;

        final x = xValue * 12 / chartWidth;
        final y = (chartHeight - yValue) * 240 / chartHeight;

        selectedSpotIndex = _findNearestSpotIndex(x, y);
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
            minX: 0,
            maxX: 12,
            minY: 0,
            maxY: 240,
          ),
        ),
      ),
    );
  }

  int? _findNearestSpotIndex(double x, double y) {
    double minDistance = double.maxFinite;
    int? nearestSpotIndex;

    for (int i = 0; i < spots.length; i++) {
      final spot = spots[i];
      final distance = (spot.x - x).abs() + (spot.y - y).abs();

      if (distance < minDistance) {
        minDistance = distance;
        nearestSpotIndex = i;
      }
    }

    return nearestSpotIndex;
  }
}

class ExampleOne extends StatelessWidget {
  const ExampleOne({Key? key}) : super(key: key);

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
