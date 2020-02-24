import 'package:autodo/localization.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:autodo/models/models.dart';
import 'package:json_intl/json_intl.dart';

class DrivingDistanceChart extends StatelessWidget {
  final List<Series<DistanceRatePoint, DateTime>> seriesList;
  final bool animate;

  DrivingDistanceChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    if (seriesList.length == 0) {
      return Center(
          child: Text(JsonIntl.of(context).get(IntlKeys.noData),
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

  @override
  Widget build(BuildContext context) => Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            ),
            Text(JsonIntl.of(context).get(IntlKeys.drivingDistanceHistory),
                style: Theme.of(context).primaryTextTheme.subtitle),
            Container(
              height: 300,
              padding: EdgeInsets.all(15),
              child: DrivingDistanceChart(data),
            )
          ]);
}
