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

enum dropdown { settings }

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.alarm)),
              Tab(icon: Icon(Icons.list)),
            ],
          ),
          title: Text('auToDo'),
          actions: <Widget>[
            PopupMenuButton<dropdown>(
              icon: Icon(Icons.more_vert),
              onSelected: (dropdown res) {
                if (res == dropdown.settings) {
                  Navigator.pushNamed(context, '/settings');
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<dropdown>>[
                    const PopupMenuItem<dropdown>(
                      value: dropdown.settings,
                      child: Text('Settings'),
                    ),
                  ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            MaintenanceHistory(),
            RefuelingHistory(),
          ],
        ),
        drawer: NavDrawer(),
        floatingActionButton:
            CreateEntryButton(addMaintenanceTodo: widget.addMaintenanceTodo),
      ),
    );
  }
}
