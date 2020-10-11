import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:charts_flutter/flutter.dart';

import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../redux/redux.dart';
import '../../../theme.dart';
import '../../../util.dart';
import 'charts/barrel.dart';
import 'constants.dart';

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          color: Theme.of(context).cardColor,
        ),
        height: 25,
      );
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) => Container(
          decoration: headerDecoration,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: HEADER_HEIGHT,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    JsonIntl.of(context).get(IntlKeys.stats),
                    style: Theme.of(context).accentTextTheme.headline1,
                  ),
                  titlePadding: EdgeInsets.all(25),
                  centerTitle: true,
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _Header(),
                    FuelMileageHistory(
                      data: vm.fuelEfficiencyData,
                      efficiencyUnit: vm.efficiencyUnits,
                    ),
                    Container(
                      color: Theme.of(context).cardColor,
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Divider(),
                    ),
                    DrivingDistanceHistory(
                      data: vm.drivingRateData,
                      distanceUnit: vm.distanceUnits,
                    ),
                    Container(
                      color: Theme.of(context).cardColor,
                      padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
                      // used to allow the user to scroll the chart above the FAB
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _ViewModel extends Equatable {
  const _ViewModel({
    @required this.drivingRateData,
    @required this.fuelEfficiencyData,
    @required this.distanceUnits,
    @required this.efficiencyUnits,
  });

  final List<Series<DrivingRatePoint, DateTime>> drivingRateData;
  final List<Series<FuelEfficiencyDataPoint, DateTime>> fuelEfficiencyData;
  final String distanceUnits;
  final String efficiencyUnits;

  static _ViewModel fromStore(Store<AppState> store) {
    if (store.state.statsState.status == StatsStatus.IDLE) {
      store.dispatch(fetchStats());
    }
    final distance = store.state.unitsState.distance;
    final intl = store.state.intlState.intl;

    final drivingRateSeries = [];
    store.state.statsState.drivingRate.data.forEach(
      (k, v) => drivingRateSeries.add(
        Series<DrivingRatePoint, DateTime>(
            id: k,
            domainFn: (DrivingRatePoint point, _) => point.time,
            measureFn: (DrivingRatePoint point, _) =>
                distance.internalToUnit(point.rate),
            measureFormatterFn: (DrivingRatePoint point, _) => (v) =>
                '${distance.format(v)} ${distance.unitString(intl, short: true)}',
            domainFormatterFn: (DrivingRatePoint point, _) => (v) => 'd',
            labelAccessorFn: (DrivingRatePoint point, _) => 'HELLO $point',
            data: v),
      ),
    );

    final fuelEfficiencySeries = [];
    store.state.statsState.fuelEfficiency.data.forEach(
      (k, v) {
        final maxMeasure = v.map((e) => e.raw).reduce(max);
        final minMeasure = v.map((e) => e.raw).reduce(min);
        fuelEfficiencySeries.add(
          Series<FuelEfficiencyDataPoint, DateTime>(
              id: 'raw_$k',
              colorFn: (FuelEfficiencyDataPoint point, _) {
                // Shade the point from red to green depending on its position relative to min/max
                final scale = scaleToUnit(point.raw, minMeasure, maxMeasure);
                final hue = scale * 120; // 0 is red, 120 is green in HSV space
                final rgb = hsv2rgb(HSV(hue, 1.0, 0.5));
                return Color(
                    r: (rgb.r * 255).toInt(),
                    g: (rgb.g * 255).toInt(),
                    b: (rgb.b * 255).toInt());
              },
              domainFn: (FuelEfficiencyDataPoint point, _) => point.time,
              measureFn: (FuelEfficiencyDataPoint point, _) =>
                  distance.internalToUnit(point.raw),
              radiusPxFn: (FuelEfficiencyDataPoint point, _) =>
                  6.0, // all values have the same radius for now
              data: v),
        );
        fuelEfficiencySeries.add(
          Series<FuelEfficiencyDataPoint, DateTime>(
              id: 'ema_$k',
              colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
              domainFn: (FuelEfficiencyDataPoint point, _) => point.time,
              measureFn: (FuelEfficiencyDataPoint point, _) => point.filtered,
              // measureUpperBoundFn: (p, idx) => 1.5 * p.efficiency, // used to shade area above/below curve
              // measureLowerBoundFn: (p, idx) => 0.667 * p.efficiency,
              data: v)
            ..setAttribute(rendererIdKey, 'customLine'),
        );
      },
    );

    return _ViewModel(
      drivingRateData: drivingRateSeries,
      fuelEfficiencyData: fuelEfficiencySeries,
      distanceUnits:
          store.state.unitsState.distance.unitString(intl, short: true),
      efficiencyUnits:
          store.state.unitsState.efficiency.unitString(intl, short: true),
    );
  }

  @override
  List get props => [drivingRateData, fuelEfficiencyData];
}
