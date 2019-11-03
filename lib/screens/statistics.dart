import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  StatisticsScreenState createState() => StatisticsScreenState();
}

class StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Text('Content to come later');
    // return Scaffold(
    //   resizeToAvoidBottomPadding:
    //       false, // used to avoid overflow when keyboard is viewable
    //   appBar: AppBar(
    //     leading: IconButton(
    //       icon: Icon(Icons.arrow_back),
    //       onPressed: () => Navigator.pop(context),
    //     ),
    //     title: Text('Statistics'),
    //   ),
    //   // key: _scaffoldKey,
    //   body: Text('Content to come later'),
    // );
  }
}
