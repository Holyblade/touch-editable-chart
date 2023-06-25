import 'package:flutter/material.dart';

class OffsetConverter {
  Offset convertToOffsetCoordinates(
      Offset cartesianPoint, Size size, int xLabels, int maxValue) {
    final double xStep = size.width / xLabels;
    final double yStep = size.height / maxValue;
    final double x = cartesianPoint.dx * xStep;
    final double y = size.height - (cartesianPoint.dy * yStep);
    return Offset(x, y);
  }
}
