import 'package:equatable/equatable.dart';

class RepeatInterval extends Equatable {
  const RepeatInterval({this.days, this.months, this.years});

  final int days;

  final int months;

  final int years;

  DateTime addToDate(DateTime date) {
    final utc = date.toUtc();
    return DateTime(utc.year + (years ?? 0),
      utc.month + (months ?? 0), utc.day + (days ?? 0)).toLocal();
  }

  @override
  List<Object> get props => [days, months, years];

  @override
  String toString() =>
      'RepeatInterval { days: $days months: $months years: $years }';
}
