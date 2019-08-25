import 'package:autodo/items/items.dart';
import 'package:flutter/material.dart';
import 'package:autodo/blocs/refueling.dart';
import 'package:autodo/sharedmodels/sharedmodels.dart';

import 'dart:async';

class RefuelingHistory extends StatefulWidget {
  @override
  State<RefuelingHistory> createState() {
    return RefuelingHistoryState();
  }
}

enum dropdown { settings }

class RefuelingHistoryState extends State<RefuelingHistory> {
  List<RefuelingItem> todos = [];
  StreamSubscription<RefuelingItem> subscription;

  @override
  void initState() {
    subscription = refuelingBLoC.stream.listen((value) {
      setState(() {
        if (todos.length != 0) {
          value.addPrevOdom(todos.last.odom);
        }
        todos.add(value);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        ],
      ),
      body: Container(
        // child: ListView.builder(
        //     itemCount: todos.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       // reverses the list so that the most recent shows up first
        //       final todo = todos[todos.length - 1 - index];
        child: FirebaseRefuelingBLoC().buildList(context),
      ),
      drawer: NavDrawer(),
      floatingActionButton: CreateEntryButton(),
    );
  }
}
