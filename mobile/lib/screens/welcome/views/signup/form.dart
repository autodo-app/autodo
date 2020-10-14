import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../../generated/localization.dart';
import '../../../../redux/redux.dart';
import '../../widgets/barrel.dart';
import '../new_user_setup/screen.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
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
                          JsonIntl.of(context).get(IntlKeys.signingUpEllipsis)),
                      CircularProgressIndicator(),
                    ],
                  ),
                  duration: Duration(
                      hours:
                          1), // overkill to make sure that it never goes away
                ),
              );
          } else if (store.state.authState.status ==
              AuthStatus.VERIFICATION_SENT) {
            Scaffold.of(context).hideCurrentSnackBar();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(JsonIntl.of(context).get(IntlKeys.verificationSent),
                    style: Theme.of(context).primaryTextTheme.headline6),
                content: Text(
                    JsonIntl.of(context)
                        .get(IntlKeys.verificationDialogContent),
                    style: Theme.of(context).primaryTextTheme.bodyText2),
                actions: [
                  FlatButton(
                    child: Text(JsonIntl.of(context).get(IntlKeys.back),
                        style: Theme.of(context).primaryTextTheme.button),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          } else if (store.state.authState.status == AuthStatus.LOGGED_IN) {
            Scaffold.of(context).hideCurrentSnackBar();
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewUserScreen(),
                ));
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
                      nextNode: _passwordNode,
                      login: false),
                  PasswordForm(
                    onSaved: (val) => _password = val,
                    node: _passwordNode,
                    login: false,
                  ),
                  (store.state.authState.status == AuthStatus.FAILED)
                      ? ErrorMessage(store.state.authState.error)
                      : Container(),
                  LegalNotice(),
                  SignupSubmitButton(onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      store.dispatch(signUpAsync(_email, _password, true));
                    }
                  }),
                  SignupToLoginButton(),
                ],
              ),
            ),
          );
        },
      );
}
