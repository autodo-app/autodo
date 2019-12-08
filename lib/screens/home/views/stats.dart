import 'package:autodo/blocs/cars.dart';
import 'package:flutter/material.dart';

import 'package:autodo/blocs/refueling.dart';
import '../charts/barrel.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  StatisticsScreenState createState() => StatisticsScreenState();
}

class StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        FutureBuilder(
            // future: RefuelingBLoC().getAllRefuelings(),
            future:
                FuelMileageHistory.prepData(RefuelingBLoC().getAllRefuelings()),
            builder: (context, snap) => (snap.hasData)
                ? FuelMileageHistory(snap.data)
                : CircularProgressIndicator()),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Divider(),
        ),
        FutureBuilder(
            future: DrivingDistanceHistory.prepData(CarsBLoC().getCars()),
            builder: (context, snap) => (snap.hasData)
                ? DrivingDistanceHistory(snap.data)
                : CircularProgressIndicator()),
      ],
    );
  }
}
