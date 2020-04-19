import 'package:flutter/material.dart';

class CarTag extends StatelessWidget {
  const CarTag({Key key, @required this.text, this.color = Colors.blue})
      : super(key: key);

  final String text;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Text(
          text,
          // style: Theme.of(context).accentTextTheme.bodyText1,
          style: TextStyle(
            fontSize: 12
          )
        ),
      ),
    );
  }
}
