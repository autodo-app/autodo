import 'package:autodo/items/items.dart';
import 'package:flutter/material.dart';
import 'package:autodo/blocs/refueling.dart';
import 'package:autodo/blocs/userauth.dart';

class RefuelingHistory extends StatefulWidget {
  @override
  State<RefuelingHistory> createState() {
    return RefuelingHistoryState();
  }
}

enum dropdown { settings }

class RefuelingHistoryState extends State<RefuelingHistory> {
  List<RefuelingItem> todos = [];

  @override
  Widget build(BuildContext context) {
    return (Auth().isLoading()) ? Container() : FirebaseRefuelingBLoC().buildList(context);
  }
}
