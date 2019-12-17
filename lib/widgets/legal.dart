import 'package:flutter/material.dart';
import 'package:autodo/localization.dart';
import 'package:autodo/theme.dart';

class PrivacyPolicy extends StatelessWidget {
  final RichText text;

  PrivacyPolicy(this.text);

  @override
  build(context) => AlertDialog(
    backgroundColor: cardColor,
    title: Text('Privacy Policy'),
    titleTextStyle: Theme.of(context).primaryTextTheme.title,
    content: SingleChildScrollView(
      child: Container(
        child: text,
      )
    ),
    contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
    actions: <Widget>[
      FlatButton(
        child: Text(
          AutodoLocalizations.gotItBang,
          style: Theme.of(context).primaryTextTheme.button,
        ),
        onPressed: () => Navigator.pop(context),
      )
    ],
  );
}
