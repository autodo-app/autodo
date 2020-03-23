import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/blocs.dart';
import '../../../../repositories/repositories.dart';
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
