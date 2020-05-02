import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import '../../../generated/localization.dart';
import '../../../theme.dart';
import 'charts/barrel.dart';
import 'constants.dart';

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(  
    decoration: BoxDecoration(  
      borderRadius: BorderRadius.only(  
        topLeft: Radius.circular(25), topRight: Radius.circular(25)
      ),
      color: Theme.of(context).cardColor,
    ),
    height: 25,
  );
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(  
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
          delegate: SliverChildListDelegate([
            _Header(),
            FuelMileageHistory(),
            Container(
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Divider(),
            ),
            DrivingDistanceHistory(),
            Container(
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
              // used to allow the user to scroll the chart above the FAB
            )],
          ),
        ),
      ],
    ),
  );
}
