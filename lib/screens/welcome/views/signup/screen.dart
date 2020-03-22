import 'package:autodo/generated/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/integ_test_keys.dart';
import 'package:json_intl/json_intl.dart';
import 'form.dart';
import 'package:autodo/routes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key key = IntegrationTestKeys.signupScreen})
      : super(key: key);

  @override
  Widget build(context) => Container(
      decoration: scaffoldBackgroundGradient(),
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.grey[300]),
              onPressed: () =>
                  Navigator.pushNamed(context, AutodoRoutes.welcome),
            ),
            title: Text(
              JsonIntl.of(context).get(IntlKeys.signUp),
              style: TextStyle(color: Colors.grey[300]),
            )),
        body: BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) => SignupForm(),
        ),
        backgroundColor: Colors.transparent,
      ));
}
