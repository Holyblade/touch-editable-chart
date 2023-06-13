import 'package:flutter/material.dart';
import 'package:touch_editable_chart/model/coffee_model.dart';
import 'package:touch_editable_chart/view/linechart_view.dart';

class LineChartExample extends StatefulWidget {
  const LineChartExample({super.key});

  @override
  State<LineChartExample> createState() => _LineChartExampleState();
}

class _LineChartExampleState extends State<LineChartExample> {
  Offset convertToOffsetCoordinates(
      Offset cartesianPoint, Size size, int xLabels, int maxValue) {
    final double xStep = size.width / xLabels;
    final double yStep = size.height / maxValue;
    final double x = cartesianPoint.dx * xStep;
    final double y = size.height - (cartesianPoint.dy * yStep);
    return Offset(x, y);
  }

  List<List<CoffeeModel>> coffee = [
    [
      CoffeeModel(minute: 0, temperature: 240),
      CoffeeModel(minute: 1, temperature: 200),
      CoffeeModel(minute: 1.5, temperature: 230),
      CoffeeModel(minute: 2, temperature: 150),
      CoffeeModel(minute: 2.5, temperature: 190),
      CoffeeModel(minute: 3, temperature: 120),
      CoffeeModel(minute: 4, temperature: 150),
      CoffeeModel(minute: 5, temperature: 130),
      CoffeeModel(minute: 6, temperature: 190),
      CoffeeModel(minute: 7, temperature: 210),
      CoffeeModel(minute: 8, temperature: 220),
      CoffeeModel(minute: 9, temperature: 230),
      CoffeeModel(minute: 10, temperature: 240),
    ],
    [
      CoffeeModel(minute: 0, temperature: 50),
      CoffeeModel(minute: 1, temperature: 20),
      CoffeeModel(minute: 1.5, temperature: 30),
      CoffeeModel(minute: 2, temperature: 40),
      CoffeeModel(minute: 2.5, temperature: 90),
      CoffeeModel(minute: 4, temperature: 70),
      CoffeeModel(minute: 6, temperature: 50),
      CoffeeModel(minute: 10, temperature: 100),
    ],
  ];

  List<Color> lineColors = [
    Colors.blue,
    Colors.green,
  ];

  final int maxValue = 240;
  final int xLabels = 10;
  final int yLabels = 12;

  @override
  Widget build(BuildContext context) {
    List<List<Offset>> lines = [];

    for (List<CoffeeModel> coffeeList in coffee) {
      List<Offset> line = [];

      for (CoffeeModel coffee in coffeeList) {
        Offset offset = convertToOffsetCoordinates(
          Offset(coffee.minute, coffee.temperature),
          Size(
              MediaQuery.of(context).size.width -
                  85, // remnova os padding da esquerda e direita
              MediaQuery.of(context).size.height -
                  70), // remova os padding do top e bottom
          xLabels,
          maxValue,
        );

        line.add(offset);
      }

      lines.add(line);
    }
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
