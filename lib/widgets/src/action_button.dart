import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:animations/animations.dart';

import '../../integ_test_keys.dart';

class AutodoActionButton extends StatefulWidget {
  const AutodoActionButton({
    Key key,
    this.mainButtonKey = IntegrationTestKeys.mainFab,
    this.miniButtonKeys = IntegrationTestKeys.fabKeys,
    this.miniButtonRoutes,
    this.miniButtonPages,
    this.ticker,
  }) : super(key: key ?? IntegrationTestKeys.fabKey);

  final Key mainButtonKey;

  final List<Key> miniButtonKeys;

  final List<MaterialPageRoute> Function() miniButtonRoutes;

  final List<Function(BuildContext)> miniButtonPages;

  final TickerProvider ticker;

  @override
  _AutodoActionButtonState createState() => _AutodoActionButtonState(
      mainButtonKey, miniButtonKeys, miniButtonRoutes, ticker);
}

class _AutodoActionButtonState extends State<AutodoActionButton>
    with SingleTickerProviderStateMixin {
  _AutodoActionButtonState(this.mainButtonKey, this.miniButtonKeys,
      this.miniButtonRoutes, this.ticker);

  AnimationController _controller;

  final Key mainButtonKey;

  final List<Key> miniButtonKeys;

  final List<MaterialPageRoute> Function() miniButtonRoutes;

  final TickerProvider ticker;

  static const List<Map<String, dynamic>> icons = [
    {
      'data': Icons.local_gas_station,
      'semanticLabel': 'Add Refueling',
    },
    {'data': Icons.build, 'semanticLabel': 'Add ToDo'},
    {'data': Icons.directions_car, 'semanticLabel': 'Add Car'}
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: ticker ?? this,
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

  Key _buttonKey(index) {
    if (miniButtonKeys == null || index >= miniButtonKeys.length) return null;
    return miniButtonKeys[index];
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).primaryColor;
    final foregroundColor = Theme.of(context).cardColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(icons.length, (int index) {
        final Widget child = Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0, 1.0 - index / icons.length / 2.0,
                  curve: Curves.easeOut),
            ),
            // child: FloatingActionButton(
            //   heroTag: null,
            //   backgroundColor: backgroundColor,
            //   mini: true,
            //   child: Icon(icons[index]['data'],
            //       color: foregroundColor,
            //       semanticLabel: icons[index]['semanticLabel'],
            //       key: _buttonKey(index)),
            //   onPressed: () {
            //     switchState();
            //     if (miniButtonRoutes != null) {
            //       Navigator.push(context, miniButtonRoutes()[index]);
            //     }
            //   },
            // ),
            child: OpenContainer(
              transitionType: ContainerTransitionType.fade,
              openBuilder: (BuildContext context, VoidCallback openContainer) {
                switchState();
                return widget.miniButtonPages[index](context);
              },
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              closedBuilder: (BuildContext context, VoidCallback openContainer) => Container(  
                height: 48.0,
                width: 48.0,
                color: backgroundColor,
                child: Icon(icons[index]['data'],
                  color: foregroundColor, 
                  semanticLabel: icons[index]['semanticLabel'],
                  key: _buttonKey(index)),
              ),
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
                onPressed: switchState,
              );
            },
          ),
        ),
    );
  }
}
