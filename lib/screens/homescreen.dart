import 'package:flutter/material.dart';
import 'package:autodo/sharedmodels/sharedmodels.dart';
import 'package:autodo/state.dart';

class HomeScreen extends StatefulWidget {
  final CarState carState;

  HomeScreen({@required this.carState}) /*: super(key: key)*/;

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
          title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            // MaintenanceToDo(), // TODO: ???
            Text('Tab 1'),
            Text('Tab 2'),
            Text('Tab 3'),
          ],
        ),
        drawer: NavDrawer(),
        floatingActionButton: CreateEntryButton(),
      ),
    );
  }
}
