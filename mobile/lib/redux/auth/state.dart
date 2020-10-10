import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'status.dart';

class AuthState extends Equatable {
  const AuthState(
      {@required this.token,
      @required this.status,
      @required this.error,
      @required this.isUserVerified});

  final String token;
  final AuthStatus status;
  final String error;
  final bool isUserVerified;

  AuthState copyWith(
          {String token,
          AuthStatus status,
          String error,
          bool isUserVerified}) =>
      AuthState(
          token: token ?? this.token,
          status: status ?? this.status,
          error: error ?? this.error,
          isUserVerified: isUserVerified ?? this.isUserVerified);

  @override
  List<Object> get props => [token, status, error, isUserVerified];

  @override
  String toString() =>
      'AuthState { token: $token, status: $status, error: $error, isUserVerified: $isUserVerified }';
}
