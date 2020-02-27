import 'package:autodo/localization.dart';
import 'package:autodo/models/models.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import 'shared.dart';

class DrivingDistanceChart extends StatelessWidget {
  final List<Series<DistanceRatePoint, DateTime>> seriesList;
  final bool animate;

  const DrivingDistanceChart(this.seriesList, {this.animate});

  int lowerBound() {
    final minVal = seriesList[0]
        .data
        .reduce((value, element) =>
            (value.distanceRate < element.distanceRate) ? value : element)
        .distanceRate;
    return (0.75 * minVal).round();
  }

  int upperBound() {
    final maxVal = seriesList[0]
        .data
        .reduce((value, element) =>
            (value.distanceRate > element.distanceRate) ? value : element)
        .distanceRate;
    return (1.25 * maxVal).round();
  }

  @override
  Widget build(BuildContext context) {
    if (seriesList.isEmpty) {
      return Center(
          child: Text(JsonIntl.of(context).get(IntlKeys.noData),
              style: Theme.of(context).primaryTextTheme.body1));
    }
    return TimeSeriesChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis: NumericAxisSpec.from(numberAxisSpec,
          tickProviderSpec: StaticNumericTickProviderSpec(
              lerp(lowerBound(), upperBound(), 6, 4))),
      // add configurations here eventually
      domainAxis: dateAxisSpec,
      // primaryMeasureAxis: numberAxisSpec,
    );
  }
}

class DrivingDistanceHistory extends StatelessWidget {
  final data;
  const DrivingDistanceHistory(this.data);

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
            ),
            Text(
              'Refueling Date',
              style: Theme.of(context).primaryTextTheme.body1,
              textAlign: TextAlign.center,
            ),
          ]);
}
