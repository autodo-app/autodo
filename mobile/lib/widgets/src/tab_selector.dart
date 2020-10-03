import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import '../../generated/localization.dart';
import '../../models/models.dart';
import '../../theme.dart';

class TabSelector extends StatelessWidget {
  const TabSelector(
      {Key key,
      @required this.activeTab,
      @required this.onTabSelected,
      this.todosTabKey,
      this.refuelingsTabKey,
      this.statsTabKey,
      this.garageTabKey})
      : super(key: key);

  final AppTab activeTab;

  final Function(AppTab) onTabSelected;

  final Key todosTabKey, refuelingsTabKey, statsTabKey, garageTabKey;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          canvasColor:
              emphasizedGray, // currently no way to override this in the main theme
        ),
        child: BottomNavigationBar(
          currentIndex: AppTab.values.indexOf(activeTab),
          onTap: (index) => onTabSelected(AppTab.values[index]),
          unselectedItemColor: Theme.of(context).accentIconTheme.color,
          selectedItemColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list, key: todosTabKey),
              label: JsonIntl.of(context).get(IntlKeys.todos),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_gas_station, key: refuelingsTabKey),
              label: JsonIntl.of(context).get(IntlKeys.refuelings),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart, key: statsTabKey),
              label: JsonIntl.of(context).get(IntlKeys.stats),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car, key: garageTabKey),
              label: JsonIntl.of(context).get(IntlKeys.garage),
            ),
          ],
        ));
  }
}
