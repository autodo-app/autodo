import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/localization.dart';

class PasswordForm extends StatelessWidget {
  final Function onSaved;
  final FocusNode node;

  PasswordForm({this.onSaved, this.node});

  @override 
  build(context) => Container(
    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
    child: TextFormField(
      obscureText: true,
      focusNode: node,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: AutodoLocalizations.password,
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
        icon: Icon(
          Icons.lock,
          color: Colors.grey[300],
        )
      ),
      onChanged: (val) => BlocProvider.of<LoginBloc>(context).add(
        LoginPasswordChanged(password: val)
      ),
      onSaved: (value) => onSaved(value.trim()),
    ),
  );
}