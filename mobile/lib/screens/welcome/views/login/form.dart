import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import '../../../../blocs/blocs.dart';
import '../../../../generated/localization.dart';
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
  Widget build(BuildContext context) => BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
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
          } else if (state is LoginLoading) {
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
          } else if (state is LoginSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
            // AutodoRoutes.home
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) => Form(
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
                            onSaved: (val) => _password = val,
                            node: _passwordNode),
                        (state is LoginError)
                            ? ErrorMessage(state.errorMsg)
                            : Container(),
                        LegalNotice(),
                        LoginSubmitButton(onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            BlocProvider.of<LoginBloc>(context).add(
                                LoginWithCredentialsPressed(
                                    email: _email, password: _password));
                          }
                        }),
                        PasswordResetButton(),
                        LoginToSignupButton(),
                      ],
                    )))),
      );
}
