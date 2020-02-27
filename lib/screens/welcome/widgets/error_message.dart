import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String msg;

  const ErrorMessage(this.msg);

  @override
  Widget build(context) => Padding(
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
