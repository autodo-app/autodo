import 'package:flutter/material.dart';
import 'package:autodo/sharedmodels/sharedmodels.dart';
import 'package:autodo/state.dart';
import 'package:autodo/maintenance/history.dart';
import 'package:autodo/refueling/history.dart';

class HomeScreen extends StatefulWidget {
  final AutodoState autodoState;
  final addMaintenanceTodo;

  HomeScreen(
      {@required this.autodoState,
      @required this.addMaintenanceTodo}) /*: super(key: key)*/;

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.alarm)),
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
          title: Text('auToDo'),
        ),
        body: TabBarView(
          children: [
            MaintenanceHistory(),
            RefuelingHistory(),
            Text('Tab 3'),
          ],
        ),
        drawer: NavDrawer(),
        floatingActionButton:
            CreateEntryButton(addMaintenanceTodo: widget.addMaintenanceTodo),
      ),
    );
  }
}
