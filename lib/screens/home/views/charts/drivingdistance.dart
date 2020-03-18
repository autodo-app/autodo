import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/localization.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/units/units.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import 'shared.dart';

class DrivingDistanceChart extends StatelessWidget {
  const DrivingDistanceChart(this.seriesList, {this.animate});

  final List<Series<DistanceRatePoint, DateTime>> seriesList;

  final bool animate;

  int lowerBound(Distance distance) {
    final minVal = seriesList[0]
        .data
        .reduce((value, element) =>
            (value.distanceRate < element.distanceRate) ? value : element)
        .distanceRate;
    return (0.75 * distance.internalToUnit(minVal)).round();
  }

  int upperBound(Distance distance) {
    final maxVal = seriesList[0]
        .data
        .reduce((value, element) =>
            (value.distanceRate > element.distanceRate) ? value : element)
        .distanceRate;
    return (1.25 * distance.internalToUnit(maxVal)).round();
  }

  @override
  Widget build(BuildContext context) {
    if (seriesList.isEmpty) {
      return Center(
          child: Text(JsonIntl.of(context).get(IntlKeys.noData),
              style: Theme.of(context).primaryTextTheme.bodyText2));
    }

    final distance = Distance.of(context);

    return TimeSeriesChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis: NumericAxisSpec.from(
        numberAxisSpec,
        tickProviderSpec: StaticNumericTickProviderSpec(
            lerp(lowerBound(distance), upperBound(distance), 6, 4)),
      ),
      // add configurations here eventually
      domainAxis: dateAxisSpec,

      // primaryMeasureAxis: numberAxisSpec,
    );
  }
}

class DrivingDistanceHistory extends StatefulWidget {
  const DrivingDistanceHistory();

  @override
  _DrivingDistanceHistoryState createState() => _DrivingDistanceHistoryState();
}

class _DrivingDistanceHistoryState extends State<DrivingDistanceHistory> {
  List<Series> data;
  String error;

  @override
  void didChangeDependencies() {
    final carsBloc = BlocProvider.of<CarsBloc>(context);

    DrivingDistanceStats.fetch(carsBloc, context).then((value) {
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
      return Text(error);
    }

    if (data == null) {
      return LoadingIndicator();
    }

    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          ),
          Text(
              JsonIntl.of(context).get(IntlKeys.drivingDistanceHistory, {
                'unit': Distance.of(context).unitString(context),
              }),
              style: Theme.of(context).primaryTextTheme.subtitle2),
          Container(
            height: 300,
            padding: EdgeInsets.all(15),
            child: DrivingDistanceChart(data),
          ),
          Text(
            JsonIntl.of(context).get(IntlKeys.refuelingDate),
            style: Theme.of(context).primaryTextTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        ]);
  }
}
