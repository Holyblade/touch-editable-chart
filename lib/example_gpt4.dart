import 'package:flutter/material.dart';

class LineChartGPT4 extends StatelessWidget {
  const LineChartGPT4({super.key});

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

class LineChart extends StatefulWidget {
  const LineChart({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  List<List<Offset>> lines = [];
  int? selectedLineIndex;
  int? selectedPointIndex;
  bool areLinesInitialized = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth * 0.8;
        double height = constraints.maxHeight * 0.7;
        if (!areLinesInitialized) {
          for (int i = 0; i < 2; i++) {
            lines.add(List.generate(
              10,
              (index) => Offset(index * width / 9, height / 2),
            ));
          }
          areLinesInitialized = true;
        }
        return GestureDetector(
          onPanUpdate: (details) {
            if (selectedLineIndex != null && selectedPointIndex != null) {
              Offset newPoint = lines[selectedLineIndex!][selectedPointIndex!] +
                  details.delta;

              double minX = selectedPointIndex! > 0
                  ? lines[selectedLineIndex!][selectedPointIndex! - 1].dx
                  : 0;
              double maxX =
                  selectedPointIndex! < lines[selectedLineIndex!].length - 1
                      ? lines[selectedLineIndex!][selectedPointIndex! + 1].dx
                      : width;

              if (newPoint.dx < minX) {
                newPoint = Offset(minX, newPoint.dy);
              } else if (newPoint.dx > maxX) {
                newPoint = Offset(maxX, newPoint.dy);
              }

              if (newPoint.dy < 0) {
                newPoint = Offset(newPoint.dx, 0);
              } else if (newPoint.dy > height) {
                newPoint = Offset(newPoint.dx, height);
              }

              setState(() {
                lines[selectedLineIndex!][selectedPointIndex!] = newPoint;
              });
            }
          },
          onPanEnd: (details) {
            selectedLineIndex = null;
            selectedPointIndex = null;
          },
          child: CustomPaint(
            size: Size(width, height),
            painter:
                LineChartPainter(lines, selectedLineIndex, selectedPointIndex),
            child: SizedBox(
              height: height,
              width: width,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (TapDownDetails details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final Offset localOffset =
                      box.globalToLocal(details.globalPosition);
                  for (int lineIndex = 0;
                      lineIndex < lines.length;
                      lineIndex++) {
                    final nearestPointIndex = lines[lineIndex].indexWhere(
                      (point) =>
                          (point.dx - 10.0 <= localOffset.dx &&
                              localOffset.dx <= point.dx + 10.0) &&
                          (point.dy - 10.0 <= localOffset.dy &&
                              localOffset.dy <= point.dy + 10.0),
                    );
                    if (nearestPointIndex != -1) {
                      setState(() {
                        selectedLineIndex = lineIndex;
                        selectedPointIndex = nearestPointIndex;
                      });
                      break;
                    }
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<List<Offset>> lines;
  final int? selectedLineIndex;
  final int? selectedPointIndex;

  LineChartPainter(this.lines, this.selectedLineIndex, this.selectedPointIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    for (int lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      final line = lines[lineIndex];
      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(line[i], line[i + 1], paint);
      }
      for (int i = 0; i < line.length; i++) {
        canvas.drawCircle(
          line[i],
          5.0,
          Paint()
            ..color = lineIndex == selectedLineIndex && i == selectedPointIndex
                ? Colors.red
                : Colors.blue,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
