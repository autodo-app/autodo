import 'package:flutter/material.dart';
import 'package:autodo/theme.dart';

// TODO: save this color data in a 'cars' document
class CarTag extends StatelessWidget {
  final String text;
  CarTag(this.text);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme.fromButtonThemeData(
      data: ButtonThemeData(
        minWidth: 0,
        padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
      ),
      child: FlatButton(
        child: Chip(
          // backgroundColor: tagPallette.shade500,
          backgroundColor: Colors.blue,
          label: Text(
            text,
            style: Theme.of(context).accentTextTheme.body2,
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}