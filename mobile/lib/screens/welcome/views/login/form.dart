import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../generated/localization.dart';
import '../../../../redux/redux.dart';
import '../../widgets/barrel.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password;
  FocusNode _emailNode, _passwordNode;

  @override
  void initState() {
    _emailNode = FocusNode()..requestFocus();
    _passwordNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StoreBuilder(
        builder: (BuildContext context, Store<AppState> store) {
          if (store.state.authState.status == AuthStatus.FAILED) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        JsonIntl.of(context).get(IntlKeys.loginFailure),
                      ),
                      Icon(Icons.error)
                    ],
                  ),
                  duration: Duration(
                      hours:
                          1), // overkill to make sure that it never goes away
                  backgroundColor: Colors.red,
                ),
              );
          } else if (store.state.authState.status == AuthStatus.LOADING) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          JsonIntl.of(context).get(IntlKeys.loggingInEllipsis)),
                      CircularProgressIndicator(),
                    ],
                  ),
                  duration: Duration(
                      hours:
                          1), // overkill to make sure that it never goes away
                ),
              );
          } else if (store.state.authState.status == AuthStatus.LOGGED_IN) {
            // AutodoRoutes.home
            Navigator.pop(context);
          }
          return Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(15),
              child: ListView(
                children: <Widget>[
                  EmailForm(
                      onSaved: (val) => _email = val,
                      node: _emailNode,
                      nextNode: _passwordNode),
                  PasswordForm(
                      onSaved: (val) => _password = val, node: _passwordNode),
                  (store.state.authState.status == AuthStatus.FAILED)
                      ? ErrorMessage(store.state.authState.error)
                      : Container(),
                  LegalNotice(),
                  LoginSubmitButton(onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      store.dispatch(logInAsync(_email, _password, true));
                    }
                  }),
                  PasswordResetButton(),
                  LoginToSignupButton(),
                ],
              ),
            ),
          );
        },
      );
}
