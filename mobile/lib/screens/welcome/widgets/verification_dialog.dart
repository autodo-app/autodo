import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../generated/localization.dart';
import '../../../redux/redux.dart';

class EmailVerificationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(JsonIntl.of(context).get(IntlKeys.verifyEmail),
            style: Theme.of(context).primaryTextTheme.headline6),
        content: Text(JsonIntl.of(context).get(IntlKeys.verifyBodyText),
            style: Theme.of(context).primaryTextTheme.bodyText2),
        actions: [
          StoreBuilder(builder: (context, Store<AppState> store) {
            if (!store.state.authState.isUserVerified) return Container();
            return FlatButton(
              child: Text(JsonIntl.of(context).get(IntlKeys.next)),
              onPressed: () {
//AutodoRoutes.newUserScreens
              },
            );
          })
        ],
      );
}
