import 'dart:math' as math;

import 'package:flutter/material.dart';

class AutodoActionButton extends StatefulWidget {
  final Key mainButtonKey;
  final List<Key> miniButtonKeys;
  AutodoActionButton({Key key, this.mainButtonKey, this.miniButtonKeys})
      : super(key: key);

  @override
  _AutodoActionButtonState createState() =>
      _AutodoActionButtonState(mainButtonKey, miniButtonKeys);
}

class _AutodoActionButtonState extends State<AutodoActionButton>
    with TickerProviderStateMixin {
  static AnimationController _controller;
  final Key mainButtonKey;
  final List<Key> miniButtonKeys;

  _AutodoActionButtonState(this.mainButtonKey, this.miniButtonKeys);

  static const List<Map<String, dynamic>> icons = [
    {
      "data": Icons.local_gas_station,
      "semanticLabel": 'Add Refueling',
    },
    {"data": Icons.build, "semanticLabel": 'Add ToDo'},
    {"data": Icons.autorenew, "semanticLabel": 'Add Repeat'},
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  void switchState() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  _buttonKey(index) {
    if (miniButtonKeys == null) return null;
    return (miniButtonKeys == null && miniButtonKeys.length >= index)
        ? null
        : miniButtonKeys[index];
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).primaryColor;
    Color foregroundColor = Theme.of(context).cardColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(icons.length, (int index) {
        Widget child = Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0, 1.0 - index / icons.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: backgroundColor,
              mini: true,
              child: Icon(icons[index]['data'],
                  color: foregroundColor,
                  semanticLabel: icons[index]['semanticLabel'],
                  key: _buttonKey(index)),
              onPressed: () {
                switchState();
                if (index == 0) {
                  Navigator.pushNamed(context, '/createRefueling');
                } else if (index == 1) {
                  Navigator.pushNamed(context, '/createTodo');
                } else if (index == 2) {
                  Navigator.pushNamed(context, '/createRepeat');
                }
              },
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return FloatingActionButton(
                key: mainButtonKey,
                heroTag: null,
                backgroundColor: ColorTween(
                  begin: Theme.of(context).primaryColor,
                  end: Theme.of(context).cardColor,
                ).evaluate(_controller),
                child: Transform(
                  transform:
                      Matrix4.rotationZ(_controller.value * 0.75 * math.pi),
                  alignment: FractionalOffset.center,
                  child: Icon(
                    Icons.add,
                    color: ColorTween(
                      begin: Theme.of(context).accentIconTheme.color,
                      end: Theme.of(context).primaryColor,
                    ).evaluate(_controller),
                  ),
                ),
                onPressed: () => switchState(),
              );
            },
          ),
        ),
    );
  }
}
