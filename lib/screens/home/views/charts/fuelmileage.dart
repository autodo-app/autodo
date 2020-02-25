import 'package:autodo/localization.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:json_intl/json_intl.dart';

class FuelMileageChart extends StatelessWidget {
  final List<Series> seriesList;
  final bool animate;

  FuelMileageChart(this.seriesList, this.animate);

  final horizAxisSpec = DateTimeAxisSpec(
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

  final vertAxisSpec = NumericAxisSpec(
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

  @override
  Widget build(BuildContext context) {
    if (seriesList.length == 0 || seriesList[0].data.length == 0) {
      return Center(
          child: Text(JsonIntl.of(context).get(IntlKeys.noData),
              style: Theme.of(context).primaryTextTheme.body1));
    }
    return TimeSeriesChart(
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

  FuelMileageHistory(this.data);

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
            )
          ]);
}
