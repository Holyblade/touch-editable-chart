import 'package:flutter/material.dart';
import 'package:touch_editable_chart/painter/linechart.painter.dart';

class LineChart extends StatefulWidget {
  final List<List<Offset>> lines;
  final List<Color> lineColors;
  final int maxValue;
  final int xLabels;
  final int yLabels;

  const LineChart(
      {Key? key,
      required this.lines,
      required this.lineColors,
      required this.maxValue,
      required this.xLabels,
      required this.yLabels})
      : super(key: key);

  @override
  LineChartState createState() => LineChartState();
}

class LineChartState extends State<LineChart> {
  int? selectedLineIndex;
  int? selectedPointIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        return GestureDetector(
          onPanUpdate: (details) {
            if (selectedLineIndex != null && selectedPointIndex != null) {
              Offset newPoint = widget.lines[selectedLineIndex!]
                      [selectedPointIndex!] +
                  details.delta;

              double minX = selectedPointIndex! > 0
                  ? widget.lines[selectedLineIndex!][selectedPointIndex! - 1].dx
                  : 0;
              double maxX = selectedPointIndex! <
                      widget.lines[selectedLineIndex!].length - 1
                  ? widget.lines[selectedLineIndex!][selectedPointIndex! + 1].dx
                  : width;

              if (newPoint.dx < minX) {
                newPoint = Offset(minX, newPoint.dy);
              } else if (newPoint.dx > maxX) {
                newPoint = Offset(maxX, newPoint.dy);
              }

              // Se a linha selecionada for a segunda, impomos a restrição
              if (selectedLineIndex == 1) {
                double minY = (height / widget.maxValue) *
                    100; // valor máximo para o eixo Y para a segunda linha
                if (newPoint.dy < height - minY) {
                  newPoint = Offset(newPoint.dx, height - minY);
                }
              }

              if (newPoint.dy < 0) {
                newPoint = Offset(newPoint.dx, 0);
              } else if (newPoint.dy > height) {
                newPoint = Offset(newPoint.dx, height);
              }

              setState(() {
                widget.lines[selectedLineIndex!][selectedPointIndex!] =
                    newPoint;
              });
            }
          },
          onTapDown: (TapDownDetails details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final Offset localOffset =
                box.globalToLocal(details.globalPosition);

            // Chamar o método printCoordinates() passando o ponto e o tamanho do gráfico
            printCoordinates(localOffset, Size(width, height), widget.xLabels,
                widget.maxValue);
          },
          onPanEnd: (details) {
            selectedLineIndex = null;
            selectedPointIndex = null;
            //print(widget.lines.toList().toString());
          },
          child: CustomPaint(
            size: Size(width, height),
            painter: LineChartPainter(
              widget.lines,
              selectedLineIndex,
              selectedPointIndex,
              xLabels: 10,
              yLabels: 12,
              maxValue: 240,
              lineColors:
                  widget.lineColors, // Defina as cores para cada linha aqui
            ),
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
                      lineIndex < widget.lines.length;
                      lineIndex++) {
                    final nearestPointIndex =
                        widget.lines[lineIndex].indexWhere(
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

  void printCoordinates(Offset point, Size size, int xLabels, int maxValue) {
    final cartesianPoint =
        convertToCartesianCoordinates(point, size, xLabels, maxValue);
    // ignore: avoid_print
    print(
        'Cartesian Coordinates: (${cartesianPoint.dx}, ${cartesianPoint.dy})');
  }

  Offset convertToOffsetCoordinates(
      Offset cartesianPoint, Size size, int xLabels, int maxValue) {
    final double xStep = size.width / xLabels;
    final double yStep = size.height / maxValue;
    final double x = cartesianPoint.dx * xStep;
    final double y = size.height - (cartesianPoint.dy * yStep);
    return Offset(x, y);
  }

  Offset convertToCartesianCoordinates(
      Offset point, Size size, int xLabels, int maxValue) {
    final double xStep = size.width / xLabels;
    final double yStep = size.height / maxValue;
    final double x = point.dx / xStep;
    final double y = (size.height - point.dy) / yStep;
    return Offset(x, y);
  }
}
