import 'package:flutter/material.dart';

class Tutorial1 extends StatelessWidget {
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
                Icons.filter_list,
                size: 160,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Text(
            "Simplify Your Tasks",
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
              "Set recurring tasks to never worry about forgetting a maintenance task again.",
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