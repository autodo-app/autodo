import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Tutorial2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 180,
            child: Center(
              child: Icon(
                Icons.done_all,
                size: 140,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Text(
            "Track Maintenance",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w600,
              color: Colors.white.withAlpha(230),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40.0, 0, 20.0, 0),
            child: Text(
              "Create todo items and recurring events that notify you on your terms.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}