import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TrialButton extends StatelessWidget {
  final buttonPadding;

  TrialButton({Key key, this.buttonPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(16.0, buttonPadding, 16.0, buttonPadding),
        child: RaisedButton(
          elevation: 12.0,
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(40.0, 14.0, 40.0, 14.0),
            child: Text(
              "TRY WITHOUT AN ACCOUNT",
              style: Theme.of(context).accentTextTheme.button,
            ),
          ),
        ),
      ),
    );
  }
}