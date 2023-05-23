import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarChartData {
  final String label;
  double value;

  BarChartData(this.label, this.value);
}

void main() {
  runApp(const TouchChartApp());
}

class TouchChartApp extends StatelessWidget {
  const TouchChartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touch Editable Bar Chart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Theme.of(context).colorScheme.onBackground,
      ),
      home: const BarChartWidget(),
    );
  }
}

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({super.key});

  @override
  BarChartWidgetState createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget> {
  List<BarChartData> data = [
    BarChartData('Bar 1', 20),
    BarChartData('Bar 2', 50),
    BarChartData('Bar 3', 80),
    BarChartData('Bar 4', 30),
  ];

  void _handleBarTapped(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    if (selectedDatum.isNotEmpty) {
      final value = selectedDatum.first.datum;
      setState(() {
        value.value += 10;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Touch Editable Bar Chart'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: charts.BarChart(
          [
            charts.Series<BarChartData, String>(
              id: 'bars',
              data: data,
              domainFn: (BarChartData bar, _) => bar.label,
              measureFn: (BarChartData bar, _) => bar.value,
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            ),
          ],
          animate: true,
          behaviors: [
            charts.SelectNearest(
              eventTrigger: charts.SelectionTrigger.tap,
              selectClosestSeries: true,
            ),
          ],
          selectionModels: [
            charts.SelectionModelConfig(
              type: charts.SelectionModelType.info,
              changedListener: _handleBarTapped,
            ),
          ],
        ),
      ),
    );
  }
}
