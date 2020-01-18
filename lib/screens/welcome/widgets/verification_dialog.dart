import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/localization.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/routes.dart';

class EmailVerificationDialog extends StatelessWidget {
  @override
  build(context) => AlertDialog(
        title: Text(AutodoLocalizations.verifyEmail,
            style: Theme.of(context).primaryTextTheme.title),
        content: Text(AutodoLocalizations.verifyBodyText,
            style: Theme.of(context).primaryTextTheme.body1),
        actions: [
          BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
            if (!(state is UserVerified)) return Container();
            return FlatButton(
              child: Text(AutodoLocalizations.next),
              onPressed: () => Navigator.popAndPushNamed(
                  context, AutodoRoutes.newUserScreens),
            );
          })
        ],
      );
}
