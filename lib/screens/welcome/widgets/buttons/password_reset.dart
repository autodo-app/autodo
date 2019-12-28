import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/localization.dart';
import 'package:autodo/theme.dart';

class _PasswordResetDialog extends StatefulWidget {
  @override
  _PasswordResetDialogState createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<_PasswordResetDialog> {
  final _passwordResetKey = GlobalKey<FormState>();
  String _email;

  @override
  build(context) => AlertDialog(
          title: Text(AutodoLocalizations.sendPasswordReset,
              style: Theme.of(context).primaryTextTheme.title),
          content: Form(
            key: _passwordResetKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // roll own email box
                TextFormField(
                  // initialValue: _emailController.text,
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: AutodoLocalizations.email,
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      icon: Icon(
                        Icons.mail,
                        color: Colors.grey[300],
                      )),
                  onChanged: (val) => BlocProvider.of<LoginBloc>(context)
                      .add(LoginEmailChanged(email: val)),
                  onSaved: (value) => _email = value.trim(),
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
                child: Text(AutodoLocalizations.back.toUpperCase(),
                    style: Theme.of(context).primaryTextTheme.button),
                onPressed: () => Navigator.pop(context)),
            FlatButton(
                child: Text(
                  AutodoLocalizations.send.toUpperCase(),
                  style: Theme.of(context).primaryTextTheme.button,
                ),
                onPressed: () {
                  BlocProvider.of<LoginBloc>(context)
                      .add(SendPasswordResetPressed(email: _email));
                  Navigator.pop(context); // dialog
                })
          ]);
}

class PasswordResetButton extends StatelessWidget {
  build(context) => FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text(
          AutodoLocalizations.forgotYourPassword,
          style: linkStyle(),
        ),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => _PasswordResetDialog(),
        ),
      );
}
