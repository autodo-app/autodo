import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import '../../../blocs/blocs.dart';
import '../../../generated/localization.dart';
import '../../../routes.dart';

class EmailVerificationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(JsonIntl.of(context).get(IntlKeys.verifyEmail),
            style: Theme.of(context).primaryTextTheme.headline6),
        content: Text(JsonIntl.of(context).get(IntlKeys.verifyBodyText),
            style: Theme.of(context).primaryTextTheme.bodyText2),
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
