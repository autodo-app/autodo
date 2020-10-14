import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage(this.msg);

  final String msg;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: Center(
          child: Text(
            msg,
            style: TextStyle(
                fontSize: 13.0,
                color: Colors.red,
                height: 1.0,
                fontWeight: FontWeight.w300),
          ),
        ),
      );
}
