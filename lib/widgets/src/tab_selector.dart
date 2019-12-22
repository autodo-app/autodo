import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/localization.dart';

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;
  final Key todosTabKey, refuelingsTabKey, statsTabKey, repeatsTabKey; 

  TabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
    this.todosTabKey,
    this.refuelingsTabKey,
    this.statsTabKey,
    this.repeatsTabKey
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.list, key: todosTabKey),
          title: Text(AutodoLocalizations.todos),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_gas_station, key: refuelingsTabKey),
          title: Text(AutodoLocalizations.refuelings),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart, key: statsTabKey),
          title: Text(AutodoLocalizations.stats),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.repeat, key: repeatsTabKey),
          title: Text(AutodoLocalizations.repeats),
        ),
      ],
    );
  }
}