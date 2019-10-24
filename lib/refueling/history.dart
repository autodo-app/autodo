import 'package:autodo/items/items.dart';
import 'package:flutter/material.dart';
import 'package:autodo/blocs/refueling.dart';
// import 'package:autodo/sharedmodels/sharedmodels.dart';
// import 'package:autodo/theme.dart';

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
    return Container(
      child: FirebaseRefuelingBLoC().buildList(context),
    );
  //   return Container(
  //     decoration: scaffoldBackgroundGradient(),
  //     child: Scaffold(
  //       backgroundColor: Colors.transparent,
  //       appBar: AppBar(
  //         title: Text('auToDo'),
  //         actions: <Widget>[
  //           PopupMenuButton<dropdown>(
  //             icon: Icon(Icons.more_vert),
  //             onSelected: (dropdown res) {
  //               if (res == dropdown.settings) {
  //                 Navigator.pushNamed(context, '/settings');
  //               }
  //             },
  //             itemBuilder: (BuildContext context) => <PopupMenuEntry<dropdown>>[
  //                   const PopupMenuItem<dropdown>(
  //                     value: dropdown.settings,
  //                     child: Text('Settings'),
  //                   ),
  //                 ],
  //           ),
  //         ],
  //         backgroundColor: Colors.transparent,
  //       ),
  //       body: Container(
  //         child: FirebaseRefuelingBLoC().buildList(context),
  //       ),
  //       drawer: NavDrawer(),
  //       floatingActionButton: CreateEntryButton(),
  //     ),
  //   );
  }
}
