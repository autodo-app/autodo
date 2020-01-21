import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';

class UpgradeDialog extends AlertDialog {
  UpgradeDialog({Key key, @required context, @required trialUser})
      : super(
            key: key,
            title: Text('Upgrade to Paid Version',
                style: Theme.of(context).primaryTextTheme.subtitle),
            content: (trialUser)
                ? Text(
                    'Trial Users cannot upgrade to the paid version of auToDo. Please create an account first.',
                    style: Theme.of(context).primaryTextTheme.body1)
                : Text(
                    'For a small, one time fee you can upgrade your account to the Paid Version of auToDo, where ads are removed.',
                    style: Theme.of(context).primaryTextTheme.body1),
            actions: (trialUser)
                ? [
                    FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('BACK',
                            style: Theme.of(context).primaryTextTheme.button))
                  ]
                : [
                    FlatButton(
                        onPressed: () {
                          BlocProvider.of<PaidVersionBloc>(context)
                              .add(PaidVersionUpgrade());
                        },
                        child: Text('PURCHASE',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .button
                                .copyWith(
                                    color: Theme.of(context).primaryColor))),
                    FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('BACK',
                            style: Theme.of(context).primaryTextTheme.button))
                  ]);
}
