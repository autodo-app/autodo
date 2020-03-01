import 'package:autodo/routes.dart';
import 'package:flutter/material.dart';

import 'package:autodo/localization.dart';
import 'package:autodo/theme.dart';
import 'package:json_intl/json_intl.dart';

class LoginToSignupButton extends StatelessWidget {
  @override
  Widget build(context) => Container(
        padding: EdgeInsets.only(top: 10.0),
        child: FlatButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Text(JsonIntl.of(context).get(IntlKeys.createAnAccount),
              style: linkStyle()),
          onPressed: () =>
              Navigator.of(context).pushNamed(AutodoRoutes.signupScreen),
        ),
      );
}
