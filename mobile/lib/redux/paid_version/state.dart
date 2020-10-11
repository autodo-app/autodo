import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'status.dart';

class PaidVersionState extends Equatable {
  const PaidVersionState({@required this.isPaid, @required this.status});

  /// True if the user has paid for the premium version of the app.
  final bool isPaid;

  /// Represents the status of fetching the Paid Version data.
  final PaidVersionStatus status;

  PaidVersionState copyWith({bool isPaid, PaidVersionStatus status}) =>
      PaidVersionState(
          isPaid: isPaid ?? this.isPaid, status: status ?? this.status);

  @override
  List get props => [isPaid, status];
}
