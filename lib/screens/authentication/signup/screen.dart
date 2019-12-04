import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:autodo/blocs/user_repository.dart';
import 'package:autodo/blocs/signup/bloc.dart';
import 'form.dart';

class SignupScreen extends StatelessWidget {
  final UserRepository _userRepository;

  SignupScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: BlocProvider<SignupBloc>(
          create: (context) => SignupBloc(userRepository: _userRepository),
          child: SignupForm(),
        ),
      ),
    );
  }
}