import 'package:flutter/material.dart';
import 'package:autodo/sharedmodels/sharedmodels.dart';
import 'package:autodo/maintenance/history.dart';
import 'package:autodo/theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

enum dropdown { settings }

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: scaffoldBackgroundGradient(),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'auToDo',
              style: logoStyle,
            ),
          ),
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
          ],
        ),
        body: MaintenanceHistory(),
        drawer: NavDrawer(),
        floatingActionButton: CreateEntryButton(),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
