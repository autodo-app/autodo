import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class TokenPair extends Equatable {
  const TokenPair({@required this.access, @required this.refresh});

  /// The primary token used to access the API. This has a short lifetime,
  /// however, and will need to be refreshed periodically.
  final String access;

  /// This is a token with a long lifetime and can be used to obtain a new
  /// access token when the access token expires.
  final String refresh;

  @override
  List<Object> get props => [access, refresh];
}
