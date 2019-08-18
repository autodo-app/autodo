import 'package:autodo/items/items.dart';
import 'package:flutter/material.dart';
import 'package:autodo/blocs/refueling.dart';
import './refuelingcard.dart';

import 'dart:async';

class RefuelingHistory extends StatefulWidget {
  @override
  State<RefuelingHistory> createState() {
    return RefuelingHistoryState();
  }
}

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
    return Container(
      // child: ListView.builder(
      //     itemCount: todos.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       // reverses the list so that the most recent shows up first
      //       final todo = todos[todos.length - 1 - index];
      child: FirebaseRefuelingBLoC().buildList(context),
    );
  }
}
