import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class LineChartGPT4Example2 extends StatelessWidget {
  const LineChartGPT4Example2({super.key});

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
                  double maxY =
                      230; // valor máximo para o eixo Y para a segunda linha
                  if (newPoint.dy > height - maxY) {
                    newPoint = Offset(newPoint.dx, height - maxY);
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
}

class LineChartPainter extends CustomPainter {
  late List<Color> lineColors;
  final List<List<Offset>> lines;
  final int? selectedLineIndex;
  final int? selectedPointIndex;
  final int xLabels; // Quantidade de rótulos no eixo X
  final int yLabels; // Quantidade de rótulos no eixo Y
  final double maxValue; // Valor máximo no eixo Y

  LineChartPainter(this.lines, this.selectedLineIndex, this.selectedPointIndex,
      {this.xLabels = 10,
      this.yLabels = 12,
      this.maxValue = 240,
      required this.lineColors});

  void _drawGrid(Canvas canvas, Size size, Paint paint) {
    final double xStep = size.width / xLabels;
    final double yStep = size.height / yLabels;

    // Desenha as linhas verticais
    for (int i = 0; i <= xLabels; i++) {
      final double linePositionX = i * xStep;
      paint.color = Colors.grey[200]!;
      paint.strokeWidth = 1;
      canvas.drawLine(
        Offset(linePositionX, 0),
        Offset(linePositionX, size.height),
        paint,
      );
    }

    // Desenha as linhas horizontais
    for (int i = 0; i <= yLabels; i++) {
      final double linePositionY = size.height - i * yStep;
      paint.color = Colors.grey[200]!;
      paint.strokeWidth = 1;
      canvas.drawLine(
        Offset(0, linePositionY),
        Offset(size.width, linePositionY),
        paint,
      );
    }

    paint.color = Colors.black;
    paint.strokeWidth = 3;
  }

  void _drawLabels(Canvas canvas, Size size, Paint paint) {
    final double xStep = size.width / xLabels;
    final double yStep = size.height / yLabels;
    final textStyle = ui.TextStyle(color: Colors.black, fontSize: 12);
    final paragraphStyle = ui.ParagraphStyle(textAlign: ui.TextAlign.right);
    for (int i = -1; i < xLabels; i++) {
      final offset =
          Offset(i * xStep, size.height + 15); // 10 pixels abaixo do eixo
      final label = (i + 1).toString();
      final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText(label);
      final paragraph = paragraphBuilder.build()
        ..layout(const ui.ParagraphConstraints(width: 30));
      canvas.drawParagraph(paragraph, offset);
    }
    for (int i = 0; i <= yLabels; i++) {
      final offset = Offset(
          -60,
          size.height -
              i * yStep -
              6); // 40 pixels à esquerda do gráfico, ajustado verticalmente pela metade da altura do texto
      final label = (maxValue / yLabels * i)
          .toStringAsFixed(1); // Formatando o valor para 1 casa decimal
      final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText(label);
      final paragraph = paragraphBuilder.build()
        ..layout(const ui.ParagraphConstraints(width: 40));
      canvas.drawParagraph(paragraph, offset);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    _drawGrid(canvas, size, paint);
    _drawLabels(canvas, size, paint);

    for (int lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      final line = lines[lineIndex];
      final lineColor = lineColors[lineIndex];
      paint.color = lineColor;

      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(line[i], line[i + 1], paint);
      }
      for (int i = 0; i < line.length; i++) {
        canvas.drawCircle(
          line[i],
          5.0,
          Paint()
            ..color = lineIndex == selectedLineIndex && i == selectedPointIndex
                ? Colors.deepPurpleAccent
                : lineColor,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
