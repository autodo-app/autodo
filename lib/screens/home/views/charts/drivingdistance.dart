import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:autodo/models/models.dart';

class DrivingDistanceChart extends StatelessWidget {
  final List<Series<DistanceRatePoint, DateTime>> seriesList;
  final bool animate;

  DrivingDistanceChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    if (seriesList.length == 0) {
      return Center(
          child: Text('No Data Available to Display.',
              style: Theme.of(context).primaryTextTheme.body1));
    }
    return TimeSeriesChart(
      seriesList,
      animate: animate,
      // add configurations here eventually
    );
  }
}

class DrivingDistanceHistory extends StatelessWidget {
  final data;
  DrivingDistanceHistory(this.data);

  static Future<List<Series<DistanceRatePoint, DateTime>>> prepData(
      Future carsGetter) async {
    var out = List<Series<DistanceRatePoint, DateTime>>();
    var cars = await carsGetter;
    for (var car in cars) {
      var points = car.distanceRateHistory;
      if (points == null || points.length == 0) continue;

      out.add(Series<DistanceRatePoint, DateTime>(
        id: car.name,
        // colorFn: (_, __) {
        //   var primaryColor = Theme.of(context).primaryColor;
        //   return Color(r: primaryColor.red, g: primaryColor.green, b: primaryColor.blue);
        // },
        domainFn: (DistanceRatePoint point, _) => point.date,
        measureFn: (DistanceRatePoint point, _) => point.distanceRate,
        data: points,
      ));
    }
    return out;
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      ),
      Text('Driving Distance History',
          style: Theme.of(context).primaryTextTheme.subtitle),
      Container(
        height: 300,
        padding: EdgeInsets.all(15),
        child: DrivingDistanceChart(data),
      )
    ]
  );
}
