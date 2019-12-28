import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screen.dart';

class LoginProvider extends StatelessWidget {
  final AuthRepository _authRepository;

  LoginProvider({@required authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository;

  @override
  build(context) => BlocProvider(
      create: (context) => LoginBloc(authRepository: _authRepository),
      child: LoginScreen());
}
