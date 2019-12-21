import 'package:autodo/repositories/barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:autodo/blocs/auth/barrel.dart';
import 'package:autodo/theme.dart';
import 'form.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key key}) : super(key: key);

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
          create: (context) => LoginBloc(
            authRepository: FirebaseAuthRepository(),
          ),
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) => LoginForm(),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}