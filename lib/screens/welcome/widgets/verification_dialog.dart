import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/localization.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/routes.dart';
import 'package:json_intl/json_intl.dart';

class EmailVerificationDialog extends StatelessWidget {
  @override
  Widget build(context) => AlertDialog(
        title: Text(JsonIntl.of(context).get(IntlKeys.verifyEmail),
            style: Theme.of(context).primaryTextTheme.title),
        content: Text(JsonIntl.of(context).get(IntlKeys.verifyBodyText),
            style: Theme.of(context).primaryTextTheme.body1),
        actions: [
          BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
            if (!(state is UserVerified)) return Container();
            return FlatButton(
              child: Text(JsonIntl.of(context).get(IntlKeys.next)),
              onPressed: () => Navigator.popAndPushNamed(
                  context, AutodoRoutes.newUserScreens),
            );
          })
        ],
      );
}
