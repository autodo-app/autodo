import 'package:equatable/equatable.dart';

class RepeatInterval extends Equatable {
  const RepeatInterval({this.days, this.months, this.years});

  final int days;

  final int months;

  final int years;

  DateTime addToDate(DateTime date) =>
    DateTime(date.year + (years ?? 0), date.month + (months ?? 0), date.day + (days ?? 0));

  @override
  List<Object> get props => [days, months, years];
}