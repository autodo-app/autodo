import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import '../../../../generated/localization.dart';
import '../../../../routes.dart';
import '../../../../theme.dart';

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
