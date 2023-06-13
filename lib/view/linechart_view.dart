import 'package:flutter/material.dart';
import 'package:touch_editable_chart/painter/linechart_painter.dart';

class LineChart extends StatefulWidget {
  const LineChart({super.key});

  @override
  LineChartState createState() => LineChartState();
}

class LineChartState extends State<LineChart> {
  List<List<Offset>> lines = [];
  List<Color> lineColors = [Colors.blue, Colors.red];
  int? selectedLineIndex;
  int? selectedPointIndex;
  bool areLinesInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
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
                Offset newPoint = lines[selectedLineIndex!]
                        [selectedPointIndex!] +
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

                // Se a linha selecionada for a segunda, impomos a restrição
                if (selectedLineIndex == 1) {
                  double minY =
                      163; // valor máximo para o eixo Y para a segunda linha
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
                  lines[selectedLineIndex!][selectedPointIndex!] = newPoint;
                });
              }
            },
            onTapDown: (TapDownDetails details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final Offset localOffset =
                  box.globalToLocal(details.globalPosition);

              // Chamar o método printCoordinates() passando o ponto e o tamanho do gráfico
              printCoordinates(localOffset, Size(width, height));
            },
            onPanEnd: (details) {
              selectedLineIndex = null;
              selectedPointIndex = null;
              //print(lines.toList().toString());
            },
            child: CustomPaint(
              size: Size(width, height),
              painter: LineChartPainter(
                lines,
                selectedLineIndex,
                selectedPointIndex,
                lineColors: [
                  Colors.blue,
                  Colors.green
                ], // Defina as cores para cada linha aqui
              ),
              child: SizedBox(
                height: height,
                width: width,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (TapDownDetails details) {
                    final RenderBox box =
                        context.findRenderObject() as RenderBox;
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
      ),
    );
  }

  void printCoordinates(Offset point, Size size) {
    final cartesianPoint = convertToCartesianCoordinates(point, size);
    print(
        'Cartesian Coordinates: (${cartesianPoint.dx}, ${cartesianPoint.dy})');
  }

  Offset convertToCartesianCoordinates(Offset point, Size size) {
    final double xStep = size.width / 11;
    final double yStep = size.height / 240;
    final double x = point.dx / xStep;
    final double y = (size.height - point.dy) / yStep;
    return Offset(x, y);
  }
}
