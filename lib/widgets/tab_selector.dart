import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:autodo/models/barrel.dart';
import 'package:autodo/localization.dart';

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  TabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          title: Text(AutodoLocalizations.todos),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_gas_station),
          title: Text(AutodoLocalizations.refuelings),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          title: Text(AutodoLocalizations.stats),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.repeat),
          title: Text(AutodoLocalizations.repeats),
        ),
      ],
    );
  }
}