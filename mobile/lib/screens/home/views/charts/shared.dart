import 'dart:math';
import 'package:charts_flutter/flutter.dart';

final dateAxisSpec = DateTimeAxisSpec(
  tickFormatterSpec: AutoDateTimeTickFormatterSpec(
    day: TimeFormatterSpec(format: 'd', transitionFormat: 'MM/dd/yyyy'),
  ),
  renderSpec: GridlineRendererSpec(
    lineStyle: LineStyleSpec(
      color: Color(r: 0x99, g: 0x99, b: 0x99, a: 100),
    ),
    labelOffsetFromAxisPx: 10,
    labelStyle: TextStyleSpec(
      fontSize: 12,
      color: MaterialPalette.white,
    ),
  ),
);

final numberAxisSpec = NumericAxisSpec(
  tickProviderSpec: BasicNumericTickProviderSpec(desiredTickCount: 6),
  renderSpec: GridlineRendererSpec(
    lineStyle: LineStyleSpec(
      color: Color(r: 0x99, g: 0x99, b: 0x99, a: 100),
    ),
    labelOffsetFromAxisPx: 10,
    labelStyle: TextStyleSpec(
      fontSize: 12,
      color: MaterialPalette.white,
    ),
  ),
);

double floorToPrecision(double val, int places) {
  final double mod = pow(10.0, places);
  return (val * mod).floor().toDouble() / mod;
}

List<TickSpec<double>> lerp(
  num min,
  num max,
  int count,
  int places,
) =>
    List.generate(
            count,
            (index) =>
                floorToPrecision(index * ((max - min) / count) + min, places))
        .map((e) => TickSpec(e))
        .toList();
