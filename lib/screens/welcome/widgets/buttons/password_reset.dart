import 'package:autodo/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/localization.dart';
import 'package:autodo/theme.dart';
import 'package:json_intl/json_intl.dart';

class _PasswordResetDialog extends StatefulWidget {
  final String email;
  final AuthRepository authRepository;
  const _PasswordResetDialog(Key key, this.email, this.authRepository)
      : super(key: key);

  @override
  _PasswordResetDialogState createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<_PasswordResetDialog> {
  final _passwordResetKey = GlobalKey<FormState>();
  String _email;

  @override
  Widget build(context) => AlertDialog(
          title: Text(JsonIntl.of(context).get(IntlKeys.sendPasswordReset),
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
                  initialValue: widget.email,
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: JsonIntl.of(context).get(IntlKeys.email),
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      icon: Icon(
                        Icons.mail,
                        color: Colors.grey[300],
                      )),
                  // onChanged: (val) => BlocProvider.of<LoginBloc>(context)
                  // .add(LoginEmailChanged(email: val)),
                  onSaved: (value) => _email = value.trim(),
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
                child: Text(
                    JsonIntl.of(context)
                        .get(IntlKeys.back)
                        .toUpperCase(), // TODO: Check uppercase
                    style: Theme.of(context).primaryTextTheme.button),
                onPressed: () => Navigator.pop(context)),
            FlatButton(
                child: Text(
                  JsonIntl.of(context)
                      .get(IntlKeys.send)
                      .toUpperCase(), // TODO: Check Uppercase
                  style: Theme.of(context).primaryTextTheme.button,
                ),
                onPressed: () {
                  // BlocProvider.of<LoginBloc>(context)
                  //     .add(SendPasswordResetPressed(email: _email));
                  _passwordResetKey.currentState.save();
                  widget.authRepository.sendPasswordReset(_email);
                  Navigator.pop(context); // dialog
                })
          ]);
}

class PasswordResetButton extends StatelessWidget {
  final Key dialogKey;

  const PasswordResetButton({this.dialogKey});

  Widget build(context) => FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text(
          JsonIntl.of(context).get(IntlKeys.forgotYourPassword),
          style: linkStyle(),
        ),
        onPressed: () {
          final bloc = BlocProvider.of<LoginBloc>(context);
          String email;
          if (bloc.state is LoginCredentialsValid) {
            email = (bloc.state as LoginCredentialsValid).email;
          } else {
            email = (bloc.state as LoginCredentialsInvalid).email;
          }
          if (email == null) return;
          showDialog(
            context: context,
            builder: (context) =>
                _PasswordResetDialog(dialogKey, email, bloc.authRepository),
          );
        },
      );
}
