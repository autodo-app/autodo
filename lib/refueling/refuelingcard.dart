import 'package:flutter/material.dart';
import 'package:autodo/items/items.dart';

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
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListTile(
              leading: FlatButton(
                  child: const Icon(Icons.check_box), onPressed: () {}),
              title: Text(widget.item.name),
              subtitle: Text(widget.item.dueDate == null
                  ? ''
                  : widget.item.dueDate.toString()),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FlatButton(
              child: const Icon(Icons.edit),
              onPressed: () {/* ... */},
            ),
          ),
        ],
      ),
    );
  }
}
