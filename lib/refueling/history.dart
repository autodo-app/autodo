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
      //       final todo = todos[index];

      //       return RefuelingCard(item: todo);
      //     }),
      child: FirebaseRefuelingBLoC().buildList(context),
    );
  }
}
