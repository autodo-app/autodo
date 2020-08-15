import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:json_intl/json_intl.dart';

import '../../../../generated/localization.dart';
import '../../../screens.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key key, this.buttonPadding}) : super(key: key);

  final double buttonPadding;

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
              onPressed: () {
//AutodoRoutes.loginScreen
                Navigator.of(context)
                  ..push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreenProvider(),
                    ),
                  );
              },
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
