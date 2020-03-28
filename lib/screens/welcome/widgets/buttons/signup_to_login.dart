import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import '../../../../generated/localization.dart';
import '../../../../routes.dart';
import '../../../../theme.dart';

class SignupToLoginButton extends StatelessWidget {
  @override
  Widget build(context) => Container(
        padding: EdgeInsets.only(top: 10.0),
        child: FlatButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Text(JsonIntl.of(context).get(IntlKeys.alreadyHaveAnAccount),
              style: linkStyle()),
          onPressed: () =>
              Navigator.of(context).pushNamed(AutodoRoutes.loginScreen),
        ),
      );
}
