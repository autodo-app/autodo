import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

import 'package:autodo/util.dart';

class FuelMileagePoint {
  DateTime date;
  double mpg;

  FuelMileagePoint({this.date, this.mpg});
}

class FuelMileageChart extends StatelessWidget {
  final List<Series> seriesList;
  final bool animate;

  FuelMileageChart(this.seriesList, this.animate);

  final horizAxisSpec = DateTimeAxisSpec(
    tickFormatterSpec: AutoDateTimeTickFormatterSpec(
      day: TimeFormatterSpec(
        format: 'd', transitionFormat: 'MM/dd/yyyy'
      ),
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

  final vertAxisSpec = NumericAxisSpec(
    tickProviderSpec: BasicNumericTickProviderSpec(
      desiredTickCount: 6
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

  @override 
  Widget build(BuildContext context) => TimeSeriesChart(
    seriesList, 
    animate: animate,
    domainAxis: horizAxisSpec,
    primaryMeasureAxis: vertAxisSpec,
    defaultRenderer: PointRendererConfig(
        customRendererId: 'customPoint',
        layoutPaintOrder: LayoutViewPaintOrder.point,
      ),
    // Custom renderer configuration for the line series.
    customSeriesRenderers: [
      PointRendererConfig(
        customRendererId: 'customPoint',
        layoutPaintOrder: LayoutViewPaintOrder.point,
      ),
      LineRendererConfig(
        // ID used to link series to this renderer.
        customRendererId: 'customLine',
        // Configure the regression line to be painted above the points.
        //
        // By default, series drawn by the point renderer are painted on
        // top of those drawn by a line renderer.
        layoutPaintOrder: LayoutViewPaintOrder.point + 1,
        stacked: true,
      ),
    ],
  );
}

class FuelMileageHistory extends StatelessWidget {
  final data;

  FuelMileageHistory(this.data);

  static interpolateDate(DateTime prev, DateTime next) {
    return DateTime.fromMillisecondsSinceEpoch(
      (prev.millisecondsSinceEpoch + next.millisecondsSinceEpoch / 2).toInt()
    );
  }

  static Future<List<Series<FuelMileagePoint, DateTime>>> prepData(Future incomingData) async {
    var rawData = await incomingData;

    List<FuelMileagePoint> points = [];
    for (var r in rawData) {
      points.add(FuelMileagePoint(date: r.date, mpg: r.efficiency));
    }

    List<FuelMileagePoint> emaData = [];
    for (var point in points) {
      if (emaData.length == 0) {
        emaData.add(point);
        continue;
      }
      FuelMileagePoint newPoint = FuelMileagePoint();
      FuelMileagePoint interpolate = FuelMileagePoint();
      FuelMileagePoint last = emaData[emaData.length - 1];
      newPoint.date = point.date;
      newPoint.mpg = last.mpg * 0.8 + point.mpg * 0.2;
      interpolate.date = interpolateDate(last.date, point.date);
      interpolate.mpg = last.mpg * 0.8 + newPoint.mpg * 0.2;
      // emaData.add(interpolate);
      emaData.add(newPoint);
    }

    // TODO: scale this according to the incoming data
    final double maxMeasure = points.map((val) => val.mpg).reduce(max);
    final double minMeasure = points.map((val) => val.mpg).reduce(min);

    return [
      Series<FuelMileagePoint, DateTime>(
        id: 'Fuel Mileage vs Time',
        // Providing a color function is optional.
        colorFn: (FuelMileagePoint point, _) {
          // Shade the point from red to green depending on its position relative to min/max
          final scale = scaleToUnit(point.mpg, minMeasure, maxMeasure);
          final hue = scale * 120; // 0 is red, 120 is green in HSV space
          final rgb = hsv2rgb(HSV(hue, 1.0, 0.5));
          return Color(r: (rgb.r * 255).toInt(), g: (rgb.g * 255).toInt(), b: (rgb.b * 255).toInt());
        },
        domainFn: (FuelMileagePoint point, _) => point.date,
        measureFn: (FuelMileagePoint point, _) => point.mpg,
        // Providing a radius function is optional.
        radiusPxFn: (FuelMileagePoint point, _) => 6.0, // all values have the same radius for now
        data: points,
      ),
      // Configure our custom line renderer for this series.
      Series<FuelMileagePoint, DateTime>(
          id: 'Mobile',
          colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
          domainFn: (FuelMileagePoint point, _) => point.date,
          measureFn: (FuelMileagePoint point, _) => point.mpg,
          data: emaData
      )..setAttribute(rendererIdKey, 'customLine'),
    ];
  }

  @override 
  Widget build(BuildContext context) => Column( 
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Padding( 
        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      ),
      Text(
        'Fuel Efficiency History',
        style: Theme.of(context).primaryTextTheme.subtitle
      ),
      Container(
        height: 300,
        padding: EdgeInsets.all(15),  
        child: FuelMileageChart(data, false),
      )
    ]
  );
}
