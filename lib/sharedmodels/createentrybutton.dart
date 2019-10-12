import 'package:autodo/blocs/notifications.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CreateEntryButton extends StatefulWidget {
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
              child: Icon(icons[index], color: foregroundColor),
              onPressed: () {
                switchState();
                if (index == 1) {
                  Navigator.pushNamed(context, '/createTodo');
                } else if (index == 0) {
                  Navigator.pushNamed(context, '/createRefueling');
                } else if (index == 2) {
                  NotificationBLoC().pushBasicNotification();
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
