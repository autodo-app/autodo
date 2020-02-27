import 'package:autodo/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:autodo/routes.dart';
import 'package:json_intl/json_intl.dart';

class LoginButton extends StatelessWidget {
  final double buttonPadding;

  const LoginButton({Key key, this.buttonPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, buttonPadding, 0.0, buttonPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              JsonIntl.of(context).get(IntlKeys.alreadyHaveAccount),
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            FlatButton(
              key: ValueKey('__welcome_login_button__'),
              onPressed: () =>
                  Navigator.pushNamed(context, AutodoRoutes.loginScreen),
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Text(
                JsonIntl.of(context).get(IntlKeys.logIn),
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
