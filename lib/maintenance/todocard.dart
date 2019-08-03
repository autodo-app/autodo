import 'package:flutter/material.dart';
import 'package:autodo/items/items.dart';

class MaintenanceTodoCard extends StatefulWidget {
  final MaintenanceTodoItem item;

  MaintenanceTodoCard({
    @required this.item,
  });

  @override
  State<MaintenanceTodoCard> createState() {
    return MaintenanceTodoCardState();
  }
}

class MaintenanceTodoCardState extends State<MaintenanceTodoCard> {
  FlatButton checkbox() {
    return FlatButton(
      child: const Icon(Icons.check_box_outline_blank, size: 36.0),
      onPressed: () {},
    );
  }

  Container due() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.alarm, size: 30.0),
              Text('Due Date'),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.directions_car, size: 30.0),
              Text('Due Mileage'),
            ],
          ),
        ],
      ),
    );
  }

  Column title() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0, 0.0),
          alignment: Alignment.center,
          child: Text(
            'Example',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24.0,
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Container body(MaintenanceTodoCard widget) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
      child: Row(
        children: <Widget>[
          checkbox(),
          due(),
        ],
      ),
    );
  }

  Row tags() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 5.0),
        ),
        ButtonTheme.fromButtonThemeData(
          data: ButtonThemeData(
            minWidth: 0,
            padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
          ),
          child: FlatButton(
            child: Chip(
              backgroundColor: Colors.lightGreen,
              label: Text("Tag1"),
            ),
            onPressed: () {},
          ),
        ),
        ButtonTheme.fromButtonThemeData(
          data: ButtonThemeData(
            minWidth: 0,
            padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
          ),
          child: FlatButton(
            child: Chip(
              backgroundColor: Colors.red,
              label: Text("Tag2"),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Row buttons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ButtonTheme.fromButtonThemeData(
          data: ButtonThemeData(
            minWidth: 0,
          ),
          child: FlatButton(
            child: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ),
        ButtonTheme.fromButtonThemeData(
          data: ButtonThemeData(
            minWidth: 0,
          ),
          child: FlatButton(
            child: const Icon(Icons.delete),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Row footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        tags(),
        buttons(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: <Widget>[
            title(),
            body(widget),
            footer(),
          ],
        ),
      ),
      // child: Row(
      //   children: <Widget>[
      //     Expanded(child: body(widget)),
      //     Align(
      //       alignment: Alignment.centerRight,
      //       child: FlatButton(
      //         child: const Icon(Icons.edit),
      //         onPressed: () {/* ... */},
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
