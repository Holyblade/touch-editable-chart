import 'package:flutter/material.dart';
import 'package:touch_editable_chart/model/airtemperature_model.dart';
import 'package:touch_editable_chart/model/coolerpower_model.dart';
import 'package:touch_editable_chart/view/linechart_view.dart';

class LineChartExample extends StatefulWidget {
  const LineChartExample({super.key});

  @override
  State<LineChartExample> createState() => _LineChartExampleState();
}

class _LineChartExampleState extends State<LineChartExample> {
  final int maxValue = 240; // max y value
  final int xLabels = 10; // max x value, each labels has 1.0 as value
  final int yLabels = 12; // y values, in this case 240/12

  List<List<Offset>> lines = [];

  List<AirTemperature> air = [
    AirTemperature(0, 240),
    AirTemperature(1, 200),
    AirTemperature(1.5, 230),
    AirTemperature(2, 150),
    AirTemperature(2.5, 190),
    AirTemperature(3, 120),
    AirTemperature(4, 150),
    AirTemperature(5, 130),
    AirTemperature(6, 190),
    AirTemperature(7, 210),
    AirTemperature(8, 220),
    AirTemperature(9, 230),
    AirTemperature(10, 240),
  ];

  List<CoolerPower> cooler = [
    CoolerPower(0, 42),
    CoolerPower(1, 65),
    CoolerPower(2, 78),
    CoolerPower(3, 91),
    CoolerPower(4, 54),
    CoolerPower(5, 76),
    CoolerPower(6, 29),
    CoolerPower(7, 83),
    CoolerPower(8, 57),
    CoolerPower(9, 39),
    CoolerPower(10, 72),
  ];

  List<Color> lineColors = [
    Colors.blue,
    Colors.green,
  ];

  Offset _convertToOffsetCoordinates(
      Offset cartesianPoint, Size size, int xLabels, int maxValue) {
    final double xStep = size.width / xLabels;
    final double yStep = size.height / maxValue;
    final double x = cartesianPoint.dx * xStep;
    final double y = size.height - (cartesianPoint.dy * yStep);
    return Offset(x, y);
  }

  void _dataLoad(BuildContext context, List<AirTemperature> airTemperature,
      List<CoolerPower> coolerPower) {
    List<Offset> data = [];
    for (AirTemperature air in airTemperature) {
      Offset offset = _convertToOffsetCoordinates(
        Offset(air.minute, air.temperature),
        Size(
            MediaQuery.of(context).size.width -
                85, // remnova os padding da esquerda e direita
            MediaQuery.of(context).size.height -
                70), // remova os padding do top e bottom
        xLabels,
        maxValue,
      );
      data.add(offset);
    }
    lines.add(data);
    data = [];
    for (CoolerPower cooler in coolerPower) {
      Offset offset = _convertToOffsetCoordinates(
        Offset(cooler.minute, cooler.power),
        Size(
            MediaQuery.of(context).size.width -
                85, // remnova os padding da esquerda e direita
            MediaQuery.of(context).size.height -
                70), // remova os padding do top e bottom
        xLabels,
        maxValue,
      );
      data.add(offset);
    }
    lines.add(data);
  }

  @override
  Widget build(BuildContext context) {
    _dataLoad(context, air, cooler);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 65, top: 20, right: 20, bottom: 50),
              child: LineChart(
                maxValue: maxValue,
                xLabels: xLabels,
                yLabels: yLabels,
                lines: lines,
                lineColors: lineColors,
              )),
        ),
      ),
    );
  }
}
