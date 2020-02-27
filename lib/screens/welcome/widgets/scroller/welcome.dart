import 'package:autodo/localization.dart';
import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 180,
            child: Center(
              child: Image.asset(
                'img/icon-only-green.png',
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Text(
            JsonIntl.of(context).get(IntlKeys.welcome),
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
          Text(
            JsonIntl.of(context).get(IntlKeys.welcomeDesc),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}
