import 'package:flutter/material.dart';
import 'package:touch_editable_chart/view/linechart_view.dart';

class LineChartExample extends StatelessWidget {
  const LineChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: LineChart(),
          ),
        ),
      ),
    );
  }
}
