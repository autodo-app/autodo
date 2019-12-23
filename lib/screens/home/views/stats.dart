import 'package:autodo/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'charts/barrel.dart';

class StatisticsScreen extends StatelessWidget {
  StatisticsScreen({Key key}) : super(key: key);

  @override
  build(context) => ListView(
    children: <Widget>[
      BlocBuilder<EfficiencyStatsBloc, EfficiencyStatsState>(
        builder: (context, state) {
          if (state is EfficiencyStatsLoaded) {
            return FuelMileageHistory(state.fuelEfficiencyData);
          } else {
            return LoadingIndicator();
          }
        } ,
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Divider(),
      ),
      BlocBuilder<DrivingDistanceStatsBloc, DrivingDistanceStatsState>(
        builder: (context, state) {
          if (state is DrivingDistanceStatsLoaded) {
            return DrivingDistanceHistory(state.drivingDistanceData);
          } else {
            return LoadingIndicator();
          }
        } ,
      ),
    ],
  );
}
