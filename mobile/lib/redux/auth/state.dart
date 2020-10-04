import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';

class AuthState extends Equatable {
  const AuthState(
      {@required this.token, @required this.status, @required this.error});

  final String token;
  final AuthStatus status;
  final String error;

  AuthState copyWith({String token, AuthStatus status, String error}) =>
      AuthState(
          token: token ?? this.token,
          status: status ?? this.status,
          error: error ?? this.error);

  @override
  List<Object> get props => [token, status, error];

  @override
  String toString() =>
      'AuthState { token: $token, status: $status, error: $error }';
}
