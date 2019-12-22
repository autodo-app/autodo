import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/routes.dart';
import 'package:autodo/localization.dart';
import '../../widgets/barrel.dart';

class LoginForm extends StatefulWidget {
  @override 
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
  build(context) => BlocListener<LoginBloc, LoginState>(
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
                    AutodoLocalizations.loginFailure,
                  ), 
                  Icon(Icons.error)
                ],
              ),
              backgroundColor: Colors.red,
            ),
          );
      }
      if (state is LoginLoading) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AutodoLocalizations.loggingInEllipsis
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
      }
      if (state is LoginSuccess) {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        Navigator.pushNamed(context, AutodoRoutes.home);
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
                nextNode: _passwordNode
              ),
              PasswordForm(
                onSaved: (val) => _password = val,
                node: _passwordNode
              ),
              (state is LoginError) ? ErrorMessage(state.errorMsg) : Container(),
              LegalNotice(),
              LoginSubmitButton( 
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    BlocProvider.of<LoginBloc>(context).add(
                      LoginWithCredentialsPressed(
                        email: _email,
                        password: _password
                      )
                    );
                    Navigator.pop(context);
                  }
                } 
              ),
              PasswordResetButton(),
              LoginToSignupButton(),
            ],
          )
        )
      )
    ),
  );
}