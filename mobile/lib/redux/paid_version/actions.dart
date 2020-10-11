import 'package:meta/meta.dart';

class PaidVersionLoadingAction {}

class SetPaidVersionAction {
  const SetPaidVersionAction({@required this.isPaid});

  final bool isPaid;
}
