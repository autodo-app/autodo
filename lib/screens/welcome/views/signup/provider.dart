import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screen.dart';

class SignupScreenProvider extends StatelessWidget {
  final AuthRepository _authRepository;

  const SignupScreenProvider({@required authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository;

  @override
  Widget build(context) => BlocProvider(
      create: (context) => SignupBloc(authRepository: _authRepository),
      child: SignupScreen());
}
