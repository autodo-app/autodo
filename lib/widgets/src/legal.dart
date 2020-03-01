import 'package:flutter/material.dart';
import 'package:autodo/localization.dart';
import 'package:autodo/theme.dart';
import 'package:json_intl/json_intl.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy(this.text, {Key key, this.buttonKey}) : super(key: key);

  final RichText text;

  final Key buttonKey;

  @override
  Widget build(context) => AlertDialog(
        backgroundColor: cardColor,
        title: Text(JsonIntl.of(context).get(IntlKeys.privacyPolicy)),
        titleTextStyle: Theme.of(context).primaryTextTheme.headline6,
        content: SingleChildScrollView(
            child: Container(
          child: text,
        )),
        contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        actions: <Widget>[
          FlatButton(
            key: buttonKey,
            child: Text(
              JsonIntl.of(context).get(IntlKeys.gotItBang),
              style: Theme.of(context).primaryTextTheme.button,
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      );
}
