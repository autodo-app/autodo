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
