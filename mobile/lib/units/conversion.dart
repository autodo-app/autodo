import 'dart:ui';

import 'package:flutter/widgets.dart';

@immutable
abstract class UnitConversion<U> {
  const UnitConversion(
    this.unit,
    this.locale,
  );

  final U unit;

  final Locale locale;

  String format(num value, {bool textField = false});

  String unitString(
    BuildContext context, {
    bool short = false,
  });

  num internalToUnit(num value);

  num unitToInternal(num value);
}
