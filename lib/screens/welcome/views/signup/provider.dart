import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screen.dart';

class SignupScreenProvider extends StatelessWidget {
  const SignupScreenProvider({@required authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Widget build(context) => BlocProvider(
      create: (context) => SignupBloc(authRepository: _authRepository),
      child: SignupScreen());
}
