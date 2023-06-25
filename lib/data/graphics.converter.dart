import 'package:flutter/material.dart';
import 'package:touch_editable_chart/data/offset.converter.dart';
import 'package:touch_editable_chart/model/airTemperature.model.dart';
import 'package:touch_editable_chart/model/fanPower.model.dart';

class GraphicsConverter {
  List<List<Offset>> dataLoad(
      BuildContext context,
      List<AirTemperature> airTemperature,
      List<FanPower> fanPower,
      int maxValue,
      int xLabels) {
    List<List<Offset>> lines = [];
    List<Offset> data = [];
    for (AirTemperature air in airTemperature) {
      Offset offset = OffsetConverter().convertToOffsetCoordinates(
        Offset(air.minute, air.temperature),
        Size(
            MediaQuery.of(context).size.width -
                85, // remnova os padding da esquerda e direita
            MediaQuery.of(context).size.height -
                70), // remova os padding do top e bottom
        xLabels,
        maxValue,
      );
      data.add(offset);
    }
    lines.add(data);
    data = [];
    for (FanPower cooler in fanPower) {
      Offset offset = OffsetConverter().convertToOffsetCoordinates(
        Offset(cooler.minute, cooler.power),
        Size(
            MediaQuery.of(context).size.width -
                85, // remnova os padding da esquerda e direita
            MediaQuery.of(context).size.height -
                70), // remova os padding do top e bottom
        xLabels,
        maxValue,
      );
      data.add(offset);
    }
    lines.add(data);
    return lines;
  }
}
