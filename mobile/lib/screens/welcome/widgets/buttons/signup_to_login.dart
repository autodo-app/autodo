import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import '../../../../generated/localization.dart';
import '../../../../theme.dart';
import '../../../screens.dart';

class SignupToLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(top: 10.0),
        child: FlatButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Text(JsonIntl.of(context).get(IntlKeys.alreadyHaveAnAccount),
              style: linkStyle()),
          onPressed: () {
            // AutodoRoutes.loginScreen
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LoginScreenProvider(),
              ),
            );
          },
        ),
      );
}
