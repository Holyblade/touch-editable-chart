import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class LineChartPainter extends CustomPainter {
  late List<Color> lineColors;
  final List<List<Offset>> lines;
  int? selectedLineIndex;
  int? selectedPointIndex;
  final int xLabels; // Quantidade de rótulos no eixo X
  final int yLabels; // Quantidade de rótulos no eixo Y
  final double maxValue; // Valor máximo no eixo Y

  LineChartPainter(
    this.lines,
    this.selectedLineIndex,
    this.selectedPointIndex, {
    this.xLabels = 10,
    this.yLabels = 12,
    this.maxValue = 240,
    required this.lineColors,
  });

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
    paint.strokeWidth = 4;
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
        size.height - i * yStep - 6,
      );
      final label = (maxValue / yLabels * i).toStringAsFixed(1);
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

      Path path = Path();
      path.moveTo(line[0].dx, size.height);
      for (int i = 0; i < line.length; i++) {
        path.lineTo(line[i].dx, line[i].dy);
      }
      path.lineTo(line[line.length - 1].dx, size.height);
      path.close();

      canvas.drawPath(
        path,
        Paint()..color = lineColor.withOpacity(0.2),
      );

      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(line[i], line[i + 1], paint);
      }
      for (int i = 0; i < line.length; i++) {
        canvas.drawCircle(
          line[i],
          4.0,
          Paint()
            ..color = lineIndex == selectedLineIndex && i == selectedPointIndex
                ? const ui.Color.fromARGB(221, 39, 33, 56)
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
