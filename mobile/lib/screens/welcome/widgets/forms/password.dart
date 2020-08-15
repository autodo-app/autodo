import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import '../../../../blocs/blocs.dart';
import '../../../../generated/localization.dart';

class PasswordForm extends StatelessWidget {
  const PasswordForm({this.onSaved, this.node, this.login = true});

  final Function onSaved;

  final FocusNode node;

  final bool login;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: TextFormField(
          obscureText: true,
          focusNode: node,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              hintText: JsonIntl.of(context).get(IntlKeys.password),
              hintStyle: TextStyle(
                color: Colors.grey[400],
              ),
              icon: Icon(
                Icons.lock,
                color: Colors.grey[300],
              )),
          onChanged: (val) {
            if (login) {
              return BlocProvider.of<LoginBloc>(context)
                  .add(LoginPasswordChanged(password: val));
            } else {
              return BlocProvider.of<SignupBloc>(context)
                  .add(SignupPasswordChanged(password: val));
            }
          },
          onSaved: (value) => onSaved(value.trim()),
        ),
      );
}
