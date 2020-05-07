import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import '../../../../blocs/blocs.dart';
import '../../../../generated/localization.dart';
import '../../../../models/models.dart';
import '../../../../units/units.dart';
import 'shared.dart';

class FuelMileageChart extends StatelessWidget {
  const FuelMileageChart(this.seriesList, {this.animate});

  final List<Series<FuelMileagePoint, DateTime>> seriesList;

  final bool animate;

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
                  style: Theme.of(context).primaryTextTheme.bodyText2)));
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

class FuelMileageHistory extends StatefulWidget {
  const FuelMileageHistory();

  @override
  _FuelMileageHistoryState createState() => _FuelMileageHistoryState();
}

class _FuelMileageHistoryState extends State<FuelMileageHistory> {
  List<Series> data;
  String error;

  static const _height = 300.0;

  @override
  void didChangeDependencies() {
    final refuelingsBloc = BlocProvider.of<RefuelingsBloc>(context);

    EfficiencyStats.fetch(refuelingsBloc, context).then((value) {
      setState(() {
        data = value;
      });
    }).catchError((e) {
      setState(() {
        error = e.toString();
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Container(  
        color: Theme.of(context).cardColor,
        height: _height,
        child: Text(error)
      );
    }

    if (data == null) {
      return Container(  
        color: Theme.of(context).cardColor,
        height: _height,
      );
    }

    return Container(  
      color: Theme.of(context).cardColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          ),
          Text(
              JsonIntl.of(context).get(IntlKeys.fuelEfficiencyHistory, {
                'unit': Efficiency.of(context).unitString(context, short: true),
              }),
              style: Theme.of(context).primaryTextTheme.subtitle2),
          Container(
            height: _height,
            padding: EdgeInsets.all(15),
            child: FuelMileageChart(data),
          ),
          Text(
            JsonIntl.of(context).get(IntlKeys.refuelingDate),
            style: Theme.of(context).primaryTextTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        ])
      );
  }
}
