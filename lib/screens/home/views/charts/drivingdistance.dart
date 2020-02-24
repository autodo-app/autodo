import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:autodo/models/models.dart';
import 'shared.dart';

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
      domainAxis: dateAxisSpec,
      primaryMeasureAxis: numberAxisSpec,
    );
  }
}

class DrivingDistanceHistory extends StatelessWidget {
  final data;
  DrivingDistanceHistory(this.data);

  @override
  Widget build(BuildContext context) => Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            ),
            Text('Driving Distance History (mi/day)',
                style: Theme.of(context).primaryTextTheme.subtitle),
            Container(
              height: 300,
              padding: EdgeInsets.all(15),
              child: DrivingDistanceChart(data),
            ),
            Text('Refueling Date', style: Theme.of(context).primaryTextTheme.body1, textAlign: TextAlign.center,),
          ]);
}
