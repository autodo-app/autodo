import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import '../../../../generated/localization.dart';

class EmailForm extends StatelessWidget {
  const EmailForm({this.onSaved, this.node, this.nextNode, this.login = true});

  final Function onSaved;

  final FocusNode node, nextNode;

  final bool login;

  @override
  Widget build(BuildContext context) => TextFormField(
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autofocus: true,
        focusNode: node,
        decoration: InputDecoration(
            hintText: JsonIntl.of(context).get(IntlKeys.email),
            hintStyle: TextStyle(
              color: Colors.grey[400],
            ),
            icon: Icon(
              Icons.mail,
              color: Colors.grey[300],
            )),
        onSaved: (value) => onSaved(value.trim()),
        onFieldSubmitted: (_) {
          node.unfocus();
          nextNode.requestFocus();
        },
      );
}
