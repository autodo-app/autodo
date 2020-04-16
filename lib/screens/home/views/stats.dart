import 'package:flutter/material.dart';

import 'charts/barrel.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        children: <Widget>[
          FuelMileageHistory(),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Divider(),
          ),
          DrivingDistanceHistory(),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
            // used to allow the user to scroll the chart above the FAB
          )
        ],
      );
}
