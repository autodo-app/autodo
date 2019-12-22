import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/localization.dart';

class EmailForm extends StatelessWidget {
  final Function onSaved;
  final FocusNode node, nextNode;

  EmailForm({this.onSaved, this.node, this.nextNode});

  @override 
  build(context) => TextFormField(
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    autofocus: true,
    focusNode: node,
    decoration: InputDecoration(
      hintText: AutodoLocalizations.email,
      hintStyle: TextStyle(
        color: Colors.grey[400],
      ),
      icon: Icon(
        Icons.mail,
        color: Colors.grey[300],
      )
    ),
    onSaved: (value) => onSaved(value.trim()),
    onChanged: (val) => BlocProvider.of<LoginBloc>(context).add(
      LoginEmailChanged(email: val)
    ),
    onFieldSubmitted: (_) {
      node.unfocus();
      nextNode.requestFocus();
    },
  );
}