import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../blocs/blocs.dart';
import '../../../../repositories/repositories.dart';
import 'screen.dart';

class SignupScreenProvider extends StatelessWidget {
  const SignupScreenProvider();

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    assert(authRepository != null);

    return BlocProvider(
        create: (context) => SignupBloc(authRepository: authRepository),
        child: SignupScreen());
  }
}
