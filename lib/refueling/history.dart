import 'package:flutter/material.dart';
import 'package:autodo/blocs/refueling.dart';

class RefuelingHistory extends StatefulWidget {
  @override
  State<RefuelingHistory> createState() {
    return RefuelingHistoryState();
  }
}

class RefuelingHistoryState extends State<RefuelingHistory> {
  @override
  Widget build(BuildContext context) {
    return RefuelingBLoC().items();
  }
}
