import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:json_intl/json_intl.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';

import '../generated/localization.dart';
import 'conversion.dart';
import 'distance.dart';
import 'volume.dart';

enum EfficiencyUnit {
  /// Miles per US gallon used in the United States, and Canada
  mpusg,

  /// Miles per imperial gallon used in the United Kingdom
  mpig,

  /// US gallons per 100 miles: Window sticker on new US cars
  usg100m,

  /// Liters per 100 kilometers (L/100 km) used in most European countries,
  /// China, South Africa, Australia, Canada and New Zealand
  lp100km,

  /// Kilometers per liter (km/L) used Americas, Asia, Africa and Oceania
  kmpl,

  /// km/20 L used in Arab countries which is known as kilometers per tanaka
  tanakeh,
}

class Efficiency extends UnitConversion<EfficiencyUnit> {
  const Efficiency(EfficiencyUnit unit, Locale locale) : super(unit, locale);

  factory Efficiency.of(BuildContext context, {bool listen = true}) =>
      Efficiency(
        EfficiencyUnit.values[Provider.of<BasePrefService>(
          context,
          listen: listen,
        ).get<int>('efficiency_unit')],
        Localizations.localeOf(context),
      );

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
      case EfficiencyUnit.lp100km:
        if (short) {
          return intl.get(IntlKeys.efficiencyLp100kmShort);
        }
        return intl.get(IntlKeys.efficiencyLp100km);

      case EfficiencyUnit.mpusg:
        if (short) {
          return intl.get(IntlKeys.efficiencyMpusgShort);
        }
        return intl.get(IntlKeys.efficiencyMpusg);

      case EfficiencyUnit.usg100m:
        if (short) {
          return intl.get(IntlKeys.efficiencyUsg100mShort);
        }
        return intl.get(IntlKeys.efficiencyUsg100m);

      case EfficiencyUnit.kmpl:
        if (short) {
          return intl.get(IntlKeys.efficiencyKmplShort);
        }
        return intl.get(IntlKeys.efficiencyKmpl);

      case EfficiencyUnit.tanakeh:
        if (short) {
          return intl.get(IntlKeys.efficiencyTanakehShort);
        }
        return intl.get(IntlKeys.efficiencyTanakeh);

      case EfficiencyUnit.mpig:
        if (short) {
          return intl.get(IntlKeys.efficiencyMpigShort);
        }
        return intl.get(IntlKeys.efficiencyMpig);
    }

    assert(false, 'Unknown unit $unit');
    return '[$unit]';
  }

  @override
  num internalToUnit(num value) {
    switch (unit) {
      case EfficiencyUnit.mpusg:
        return value / Distance.miles * Volume.usLiquidGallon;
      case EfficiencyUnit.mpig:
        return value / Distance.miles * Volume.imperialGallon;
      case EfficiencyUnit.usg100m:
        return Distance.miles * 100 / value * Volume.usLiquidGallon;
      case EfficiencyUnit.lp100km:
        return Distance.kilometer * 100 / value * Volume.liter;
      case EfficiencyUnit.kmpl:
        return value;
      case EfficiencyUnit.tanakeh:
        return value / 20;
    }

    throw UnimplementedError('Unit $unit not implemented');
  }

  @override
  num unitToInternal(num value) {
    switch (unit) {
      case EfficiencyUnit.mpusg:
        return value * Distance.miles / Volume.usLiquidGallon;
      case EfficiencyUnit.mpig:
        return value * Distance.miles / Volume.imperialGallon;
      case EfficiencyUnit.usg100m:
        return Volume.usLiquidGallon / value * Distance.miles * 100;
      case EfficiencyUnit.lp100km:
        return Volume.liter / value * Distance.kilometer * 100;
      case EfficiencyUnit.kmpl:
        return value;
      case EfficiencyUnit.tanakeh:
        return value * 20;
    }

    throw UnimplementedError('Unit $unit not implemented');
  }

  static EfficiencyUnit getDefault(Locale locale) {
    switch (locale.countryCode) {
      case 'US':
        return EfficiencyUnit.mpusg;
      case 'GB':
        return EfficiencyUnit.mpig;
    }

    return EfficiencyUnit.lp100km;
  }
}
