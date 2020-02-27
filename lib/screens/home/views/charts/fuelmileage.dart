import 'package:autodo/localization.dart';
import 'package:autodo/models/models.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import 'shared.dart';

class FuelMileageChart extends StatelessWidget {
  final List<Series<FuelMileagePoint, DateTime>> seriesList;
  final bool animate;

  const FuelMileageChart(this.seriesList, this.animate);

  int lowerBound() {
    final minVal = seriesList[0]
        .data
        .reduce((value, element) =>
            (value.efficiency < element.efficiency) ? value : element)
        .efficiency;
    return (0.75 * minVal).round();
  }

  int upperBound() {
    final maxVal = seriesList[0]
        .data
        .reduce((value, element) =>
            (value.efficiency > element.efficiency) ? value : element)
        .efficiency;
    return (1.25 * maxVal).round();
  }

  @override
  Widget build(BuildContext context) {
    if (seriesList.isEmpty || seriesList[0].data.isEmpty) {
      return Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Center(
              child: Text(JsonIntl.of(context).get(IntlKeys.noDataRefuelings),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).primaryTextTheme.body1)));
    }
    return TimeSeriesChart(
      seriesList,
      animate: animate,
      domainAxis: dateAxisSpec,
      primaryMeasureAxis: NumericAxisSpec.from(numberAxisSpec,
          // tickProviderSpec: StaticNumericTickProviderSpec([
          // TickSpec(lowerBound()),
          // TickSpec(upperBound())
          // ])),
          tickProviderSpec: StaticNumericTickProviderSpec(
              lerp(lowerBound(), upperBound(), 6, 1))),
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
          customRendererId: 'customLine',
          layoutPaintOrder: LayoutViewPaintOrder.point + 1,
          stacked: true,
        ),
      ],
    );
  }
}

class FuelMileageHistory extends StatelessWidget {
  final data;

  const FuelMileageHistory(this.data);

  @override
  Widget build(BuildContext context) => Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            ),
            Text(JsonIntl.of(context).get(IntlKeys.fuelEfficiencyHistory),
                style: Theme.of(context).primaryTextTheme.subtitle),
            Container(
              height: 300,
              padding: EdgeInsets.all(15),
              child: FuelMileageChart(data, false),
            ),
            Text(
              'Refueling Date',
              style: Theme.of(context).primaryTextTheme.body1,
              textAlign: TextAlign.center,
            ),
          ]);
}
