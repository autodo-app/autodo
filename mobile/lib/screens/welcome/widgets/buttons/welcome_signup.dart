import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import '../../../../generated/localization.dart';
import '../../../screens.dart';

class SignupButton extends StatelessWidget {
  const SignupButton({Key key, this.buttonPadding}) : super(key: key);

  final double buttonPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, buttonPadding, 16.0, buttonPadding),
        child: Hero(
          tag: 'SignupButton',
          transitionOnUserGestures: true,
          child: RaisedButton(
            elevation: 24.0,
            onPressed: () {
              // AutodoRoutes.signupScreen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SignupScreen(),
                ),
              );
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
                JsonIntl.of(context).get(IntlKeys.signUp),
                style: Theme.of(context).accentTextTheme.button,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
