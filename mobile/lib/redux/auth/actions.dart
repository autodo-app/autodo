import 'package:meta/meta.dart';

class LoginPendingAction {}

class LoginFailedAction {
  const LoginFailedAction({@required this.error});

  final String error;
}

class LoginSuccessAction {
  const LoginSuccessAction({@required this.token});

  final String token;
}

class SignupPendingAction {}

class SignupFailedAction {
  const SignupFailedAction({@required this.error});

  final String error;
}

class SignupSuccessAction {
  const SignupSuccessAction({@required this.token});

  final String token;
}

class LogOutSuccessAction {}
