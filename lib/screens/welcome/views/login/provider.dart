import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../blocs/blocs.dart';
import '../../../../repositories/repositories.dart';
import 'screen.dart';

class LoginScreenProvider extends StatelessWidget {
  const LoginScreenProvider();

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    assert(authRepository != null);

    return BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authRepository: authRepository),
        child: LoginScreen());
  }
}
