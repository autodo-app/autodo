import 'package:autodo/items/maintenancetodo.dart';
import 'package:autodo/screens/createmaintenancetodo.dart';
// import 'package:autodo/sharedmodels/expanding_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:autodo/state.dart';

class CreateEntryButton extends StatefulWidget {
  final addMaintenanceTodo;

  CreateEntryButton({@required this.addMaintenanceTodo});

  @override
  State<StatefulWidget> createState() {
    return CreateEntryButtonState();
  }
}

class CreateEntryButtonState extends State<CreateEntryButton>
    with TickerProviderStateMixin {
  static AnimationController _controller;

  static const List<IconData> icons = const [
    Icons.local_gas_station,
    Icons.build,
    Icons.alarm
  ];

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(icons.length, (int index) {
        Widget child = new Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: new FloatingActionButton(
              heroTag: null,
              backgroundColor: backgroundColor,
              mini: true,
              child: new Icon(icons[index], color: foregroundColor),
              onPressed: () {
                if (index == 1) {
                  widget.addMaintenanceTodo(
                      MaintenanceTodoItem(name: 'New Item'));
                } else if (index == 2) {
                  // CreateMaintenanceTodoPage();
                  // ExpandingBottomSheet();
                  // settingModalBottomSheet(context);
                  // CreateTodoScreen();
                  Navigator.pushNamed(context, '/createTodo');
                }
              },
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          new FloatingActionButton(
            heroTag: null,
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform:
                      new Matrix4.rotationZ(_controller.value * 0.25 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(Icons.add),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
    );
  }
}
