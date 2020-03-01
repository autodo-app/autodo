import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screen.dart';

class LoginScreenProvider extends StatelessWidget {
  const LoginScreenProvider({@required authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Widget build(context) => BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(authRepository: _authRepository),
      child: LoginScreen());
}
