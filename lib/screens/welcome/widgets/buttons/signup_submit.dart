import 'package:flutter/material.dart';

import 'package:autodo/localization.dart';

class SignupSubmitButton extends StatelessWidget {
  final Function onPressed;

  SignupSubmitButton({this.onPressed});

  @override
  build(context) => Container(
        padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            color: Theme.of(context).primaryColor,
            child: Text(
              AutodoLocalizations.signup,
              style: Theme.of(context).accentTextTheme.button,
            ),
            onPressed: () => onPressed(),
          ),
        ),
      );
}
