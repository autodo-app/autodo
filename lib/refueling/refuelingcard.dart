import 'package:flutter/material.dart';
import 'package:autodo/items/items.dart';
import 'package:intl/intl.dart';

class RefuelingCard extends StatefulWidget {
  final RefuelingItem item;

  RefuelingCard({
    @required this.item,
  });

  @override
  State<RefuelingCard> createState() {
    return RefuelingCardState();
  }
}

class RefuelingCardState extends State<RefuelingCard> {
  Widget checkbox(RefuelingCard widget) {
    return Row();
  }

  // Row dueDate(DateTime date) {
  //   bool isDate = date != null;
  //   if (isDate) {
  //     return Row(
  //       children: <Widget>[
  //         Icon(Icons.alarm, size: 30.0),
  //         Text('Due on ' + DateFormat("MM/dd/yyyy").format(date)),
  //       ],
  //     );
  //   } else {
  //     return Row();
  //   }
  // }

  // Row dueMileage(int mileage) {
  //   bool isMileage = mileage != null;
  //   if (isMileage) {
  //     return Row(
  //       children: <Widget>[
  //         Icon(Icons.directions_car, size: 30.0),
  //         Text('Due at ' + mileage.toString() + ' miles'),
  //       ],
  //     );
  //   } else {
  //     return Row();
  //   }
  // }

  Container stats(RefuelingCard widget) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.wb_auto),
              Text(widget.item.mpg.toString() + ' mpg'),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.attach_money),
              Text(widget.item.costpergal.toString() + ' USD/gal'),
            ],
          )
        ],
      ),
    );
  }

  Column title(RefuelingCard widget) {
    DateTime date = widget.item.date;
    String dateStr =
        date != null ? ' on ' + DateFormat("MM/dd/yyyy").format(date) : '';
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0, 0.0),
          alignment: Alignment.center,
          child: Text(
            'Refueling' +
                dateStr +
                ' at ' +
                widget.item.odom.toString() +
                ' miles',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: dateStr == '' ? 24.0 : 18.0,
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Container body(RefuelingCard widget) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
      child: Row(
        children: <Widget>[
          checkbox(widget),
          stats(widget),
        ],
      ),
    );
  }

  Row tags(RefuelingCard widget) {
    List<Widget> tags = [
      Padding(
        padding: EdgeInsets.only(left: 5.0),
      ),
    ];
    for (var tag in widget.item.tags) {
      tags.add(
        ButtonTheme.fromButtonThemeData(
          data: ButtonThemeData(
            minWidth: 0,
            padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
          ),
          child: FlatButton(
            child: Chip(
              backgroundColor: Colors.lightGreen,
              label: Text(tag),
            ),
            onPressed: () {},
          ),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: tags,
    );
  }

  Row buttons(RefuelingCard widget) {
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

  Row footer(RefuelingCard widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        tags(widget),
        buttons(widget),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: <Widget>[
            title(widget),
            body(widget),
            footer(widget),
          ],
        ),
      ),
    );
  }
}
