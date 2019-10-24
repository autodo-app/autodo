import 'package:flutter/material.dart';
import 'package:autodo/blocs/todo.dart';

class MaintenanceHistory extends StatefulWidget {
  @override
  State<MaintenanceHistory> createState() {
    return MaintenanceHistoryState();
  }
}

class MaintenanceHistoryState extends State<MaintenanceHistory> with AutomaticKeepAliveClientMixin {
  FirebaseTodoBLoC fb = FirebaseTodoBLoC();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (fb.isLoading()) {
      return Center(child: CircularProgressIndicator(),);
    } else {
      return Container(
      child: fb.buildList(context),
    );
    }
  }

  @override 
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
