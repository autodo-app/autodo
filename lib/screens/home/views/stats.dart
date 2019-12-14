import 'package:autodo/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

import 'package:autodo/blocs/barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'charts/barrel.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  StatisticsScreenState createState() => StatisticsScreenState();
}

class StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<EfficiencyStatsBloc>(
        create: (context) => EfficiencyStatsBloc(  
          refuelingsBloc: BlocProvider.of<RefuelingsBloc>(context),
        ),
      ),
      BlocProvider<DrivingDistanceStatsBloc>(
        create: (context) => DrivingDistanceStatsBloc(  
          refuelingsBloc: BlocProvider.of<RefuelingsBloc>(context),
        ),
      ),
    ],
    child: ListView(
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
    )
  );
}
