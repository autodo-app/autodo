import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import '../../../../generated/localization.dart';
import '../../../../theme.dart';
import 'form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('__login_screen__'),
      decoration: scaffoldBackgroundGradient(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey[300]),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            JsonIntl.of(context).get(IntlKeys.logIn),
            style: TextStyle(color: Colors.grey[300]),
          ),
        ),
        body: LoginForm(),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
