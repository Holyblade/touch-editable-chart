import 'package:flutter/material.dart';
import 'package:touch_editable_chart/data/graphics.converter.dart';
import 'package:touch_editable_chart/model/airTemperature.model.dart';
import 'package:touch_editable_chart/model/fanPower.model.dart';
import 'package:touch_editable_chart/view/linechart.view.dart';

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
  List<Color> lineColors = [
    Colors.blue,
    Colors.green,
  ];

  List<AirTemperature> airTemperature = [
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

  List<FanPower> fanPower = [
    FanPower(0, 42),
    FanPower(1, 65),
    FanPower(2, 78),
    FanPower(3, 91),
    FanPower(4, 54),
    FanPower(5, 76),
    FanPower(6, 29),
    FanPower(7, 83),
    FanPower(8, 57),
    FanPower(9, 39),
    FanPower(10, 72),
  ];

  @override
  void initState() {
    super.initState();
    lines = GraphicsConverter()
        .dataLoad(context, airTemperature, fanPower, maxValue, xLabels);
  }

  @override
  Widget build(BuildContext context) {
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
