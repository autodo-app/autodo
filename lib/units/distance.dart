import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:json_intl/json_intl.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

import '../generated/localization.dart';
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

  // The constants here are defined to convert as:
  // display_value = internal_value / constant
  // and the expression `10 * miles` stores 10 miles into the database

  /// 1 kilometer is 1000 meters
  static const kilometer = 1.0;

  /// The international mile is precisely equal to 1.609344 km
  /// It is used in Liberia, Myanmar, the United Kingdom and the United States
  static const miles = 1.609344 * kilometer;

  @override
  String format(num value, {bool textField = false}) {
    if (value == null) {
      return '';
    }

    value = internalToUnit(value);

    if (textField) {
      return value.round().toString();
    }

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

  // For now the database values are in miles
  @override
  num internalToUnit(num value) {
    switch (unit) {
      case DistanceUnit.metric:
        return value / kilometer;
      case DistanceUnit.imperial:
        return value / miles;
    }

    throw UnimplementedError('Unit $unit not implemented');
  }

  // For now the database values are in miles
  @override
  num unitToInternal(num value) {
    switch (unit) {
      case DistanceUnit.metric:
        return value * kilometer;
      case DistanceUnit.imperial:
        return value * miles;
    }

    throw UnimplementedError('Unit $unit not implemented');
  }

  static DistanceUnit getDefault(Locale locale) {
    switch (locale.countryCode) {
      case 'US':
      case 'GB':
        return DistanceUnit.imperial;
    }

    return DistanceUnit.metric;
  }
}
