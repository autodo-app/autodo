import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:autodo/blocs/user_repository.dart';
import 'package:autodo/blocs/login/bloc.dart';
import './login_form.dart';
import 'package:autodo/theme.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: scaffoldBackgroundGradient(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey[300]),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            // widget.formMode == FormMode.LOGIN ? 'LOG IN' : 'SIGN UP',
            'LOG IN',
            style: TextStyle(color: Colors.grey[300]),
          ),
        ),
        body: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(userRepository: _userRepository),
          child: LoginForm(userRepository: _userRepository),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}