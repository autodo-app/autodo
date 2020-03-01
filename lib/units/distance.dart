import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:json_intl/json_intl.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

import '../localization.dart';
import 'conversion.dart';

enum DistanceUnit { metric, imperial }

class Distance extends UnitConversion<DistanceUnit> {
  const Distance(DistanceUnit unit, Locale locale) : super(unit, locale);

  factory Distance.of(BuildContext context, {bool listen = true}) => Distance(
        DistanceUnit.values[Provider.of<BasePrefService>(
          context,
          listen: listen,
        ).getInt('length_unit')],
        Localizations.localeOf(context),
      );

  static const kilometer = 1000.0;
  static const miles = 1.609344 * kilometer;

  @override
  String format(num value) {
    if (value == null) {
      return '';
    }

    value = internalToUnit(value);
    return NumberFormat(',###', locale.toLanguageTag()).format(value);
  }

  @override
  String unitString(BuildContext context, {bool short = false}) {
    final intl = JsonIntl.of(context);

    switch (unit) {
      case DistanceUnit.metric:
        if (short) {
          return intl.get(IntlKeys.distanceKmShort);
        }
        return intl.get(IntlKeys.distanceKm);

      case DistanceUnit.imperial:
        if (short) {
          return intl.get(IntlKeys.distanceMilesShort);
        }
        return intl.get(IntlKeys.distanceMiles);
    }

    assert(false, 'Unknown unit $unit');
    return '[$unit]';
  }

  // Todo: Change database unit to SI.
  // For now the database values are in miles
  @override
  num internalToUnit(num value) {
    switch (unit) {
      case DistanceUnit.metric:
        return value * miles / kilometer;
      case DistanceUnit.imperial:
        return value;
    }

    throw UnimplementedError('Unit $unit not implemented');
  }

  // Todo: Change database unit to SI.
  // For now the database values are in miles
  @override
  num unitToInternal(num value) {
    switch (unit) {
      case DistanceUnit.metric:
        return value * kilometer / miles;
      case DistanceUnit.imperial:
        return value;
    }

    throw UnimplementedError('Unit $unit not implemented');
  }

  static DistanceUnit getDefault(Locale locale) => DistanceUnit.metric;
}
