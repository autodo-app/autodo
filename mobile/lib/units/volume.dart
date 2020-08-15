import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:json_intl/json_intl.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';

import '../generated/localization.dart';
import 'conversion.dart';

enum VolumeUnit { metric, imperial, us }

class Volume extends UnitConversion<VolumeUnit> {
  const Volume(VolumeUnit unit, Locale locale) : super(unit, locale);

  factory Volume.of(BuildContext context, {bool listen = true}) => Volume(
        VolumeUnit.values[Provider.of<BasePrefService>(
          context,
          listen: listen,
        ).get<int>('volume_unit')],
        Localizations.localeOf(context),
      );

  // The constants here are defined to convert as:
  // display_value = internal_value / constant
  // and the expression `10 * usLiquidGallon` stores 10 US gallons into the database

  /// 1 liter is 1 cubic decimeter, which is 0.001 cubic meter
  static const liter = 1.0;

  /// Used in the United Kingdom and some Caribbean nations
  static const imperialGallon = 4.54609 * liter;

  /// Used in the US and some Latin American and Caribbean countries
  static const usLiquidGallon = 3.785411784 * liter;

  /// Not really used for commerce
  static const usDryGallon = 4.40488377086 * liter;

  @override
  String format(num value, {bool textField = false}) {
    if (value == null) {
      return '';
    }

    value = internalToUnit(value);

    if (textField) {
      return value.toStringAsFixed(2);
    }

    return NumberFormat(',###.0#', locale.toLanguageTag()).format(value);
  }

  @override
  String unitString(BuildContext context, {bool short = false}) {
    final intl = JsonIntl.of(context);

    switch (unit) {
      case VolumeUnit.metric:
        if (short) {
          return intl.get(IntlKeys.fuelLitersShort);
        }
        return intl.get(IntlKeys.fuelLiters);
      case VolumeUnit.imperial:
        if (short) {
          return intl.get(IntlKeys.fuelGallonsImperialShort);
        }
        return intl.get(IntlKeys.fuelGallonsImperial);
      case VolumeUnit.us:
        if (short) {
          return intl.get(IntlKeys.fuelGallonsUsShort);
        }
        return intl.get(IntlKeys.fuelGallonsUs);
    }

    assert(false, 'Unknown unit $unit');
    return '[$unit]';
  }

  // For now the database values are in US gallons
  @override
  num internalToUnit(num value) {
    switch (unit) {
      case VolumeUnit.metric:
        return value / liter;

      case VolumeUnit.imperial:
        return value / imperialGallon;

      case VolumeUnit.us:
        return value / usLiquidGallon;
    }

    throw UnimplementedError('Unit $unit not implemented');
  }

  // For now the database values are in US gallons
  @override
  num unitToInternal(num value) {
    switch (unit) {
      case VolumeUnit.metric:
        return value * liter;

      case VolumeUnit.imperial:
        return value * imperialGallon;

      case VolumeUnit.us:
        return value * usLiquidGallon;
    }

    throw UnimplementedError('Unit $unit not implemented');
  }

  static VolumeUnit getDefault(Locale locale) {
    switch (locale.countryCode) {
      case 'US':
        return VolumeUnit.us;
      case 'GB':
        return VolumeUnit.imperial;
    }

    return VolumeUnit.metric;
  }
}
