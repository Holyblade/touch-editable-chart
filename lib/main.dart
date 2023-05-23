// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

// class BarChartData {
//   final String label;
//   double value;

//   BarChartData(this.label, this.value);
// }

// void main() {
//   runApp(const TouchChartApp());
// }

// class TouchChartApp extends StatelessWidget {
//   const TouchChartApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Touch Editable Bar Chart',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Theme.of(context).colorScheme.onBackground,
//       ),
//       home: const BarChartWidget(),
//     );
//   }
// }

// class BarChartWidget extends StatefulWidget {
//   const BarChartWidget({super.key});

//   @override
//   BarChartWidgetState createState() => BarChartWidgetState();
// }

// class BarChartWidgetState extends State<BarChartWidget> {
//   List<BarChartData> data = [
//     BarChartData('Bar 1', 20),
//     BarChartData('Bar 2', 50),
//     BarChartData('Bar 3', 80),
//     BarChartData('Bar 4', 30),
//   ];

//   void _handleBarTapped(charts.SelectionModel model) {
//     final selectedDatum = model.selectedDatum;
//     if (selectedDatum.isNotEmpty) {
//       final value = selectedDatum.first.datum;
//       //final a = selectedDatum.first.index; -- posição do ponto no gráfico (index 0,1,2,3,etc)

//       //print(a);
//       setState(() {
//         value.value += 1;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Touch Editable Bar Chart'),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(16),
//         child: charts.BarChart(
//           [
//             charts.Series<BarChartData, String>(
//               id: 'bars',
//               data: data,
//               domainFn: (BarChartData bar, _) => bar.label,
//               measureFn: (BarChartData bar, _) => bar.value,
//               colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//             ),
//           ],
//           animate: true,
//           behaviors: [
//             charts.SelectNearest(
//               eventTrigger: charts.SelectionTrigger.tap,
//               selectClosestSeries: true,
//             ),
//           ],
//           selectionModels: [
//             charts.SelectionModelConfig(
//               type: charts.SelectionModelType.info,
//               changedListener: _handleBarTapped,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';

// void main() {
//   return runApp(_ChartApp());
// }

// class _ChartApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: _MyHomePage(),
//     );
//   }
// }

// class _MyHomePage extends StatefulWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<_MyHomePage> {
//   List<_SalesData> data = [
//     _SalesData('Jan', 35),
//     _SalesData('Feb', 28),
//     _SalesData('Mar', 34),
//     _SalesData('Apr', 32),
//     _SalesData('May', 40)
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Syncfusion Flutter chart'),
//       ),
//       body: Column(
//         children: [
//           //Initialize the chart widget
//           SfCartesianChart(
//               primaryXAxis: CategoryAxis(),
//               // Chart title
//               title: ChartTitle(text: 'Half yearly sales analysis'),
//               // Enable legend
//               legend: Legend(isVisible: true),
//               // Enable tooltip
//               tooltipBehavior: TooltipBehavior(
//                   enable: true, tooltipPosition: TooltipPosition.auto),
                  
//               series: <ChartSeries<_SalesData, String>>[
//                 LineSeries<_SalesData, String>(
//                     dataSource: data,
//                     xValueMapper: (_SalesData sales, _) => sales.year,
//                     yValueMapper: (_SalesData sales, _) => sales.sales,
//                     name: 'Sales',
//                     // Enable data label
//                     dataLabelSettings: const DataLabelSettings(isVisible: true))
//               ]),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               //Initialize the spark charts widget
//               child: SfSparkLineChart.custom(
//                 //Enable the trackball
//                 trackball: const SparkChartTrackball(
//                     activationMode: SparkChartActivationMode.tap),
//                 //Enable marker
//                 marker: const SparkChartMarker(
//                     displayMode: SparkChartMarkerDisplayMode.all),
//                 //Enable data label
//                 labelDisplayMode: SparkChartLabelDisplayMode.all,
//                 xValueMapper: (int index) => data[index].year,
//                 yValueMapper: (int index) => data[index].sales,
//                 dataCount: 5,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SalesData {
//   _SalesData(this.year, this.sales);

//   final String year;
//   final double sales;
// }
