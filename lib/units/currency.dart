import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:preferences/preferences.dart';

import 'conversion.dart';

class Currency extends UnitConversion<String> {
  const Currency(String unit, Locale locale) : super(unit, locale);

  factory Currency.of(BuildContext context) => Currency(
        PrefService.of(context).getString('currency'),
        Localizations.localeOf(context),
      );

  @override
  String format(num value) {
    return NumberFormat.simpleCurrency(
      locale: locale.toLanguageTag(),
      name: unit,
    ).format(value);
  }

  @override
  String unitString(BuildContext context, {bool short = false}) {
    return unit;
  }

  @override
  num internalToUnit(num value) {
    return value;
  }

  @override
  num unitToInternal(num value) {
    return value;
  }

  static String getDefault(Locale locale) => 'USD';

  static const currencies = <String>[
    'AFN',
    'TOP',
    'MGA',
    'THB',
    'PAB',
    'ETB',
    'VEF',
    'BOB',
    'GHS',
    'CRC',
    'NIO',
    'GMD',
    'MKD',
    'BHD',
    'DZD',
    'IQD',
    'JOD',
    'KWD',
    'LYD',
    'RSD',
    'TND',
    'AED',
    'MAD',
    'STD',
    'BSD',
    'FJD',
    'GYD',
    'KYD',
    'LRD',
    'SBD',
    'SRD',
    'AUD',
    'BBD',
    'BMD',
    'BND',
    'BZD',
    'CAD',
    'HKD',
    'JMD',
    'NAD',
    'NZD',
    'SGD',
    'TTD',
    'TWD',
    'USD',
    'XCD',
    'VND',
    'AMD',
    'CVE',
    'EUR',
    'AWG',
    'HUF',
    'BIF',
    'CDF',
    'CHF',
    'DJF',
    'GNF',
    'RWF',
    'XOF',
    'XPF',
    'KMF',
    'XAF',
    'HTG',
    'PYG',
    'UAH',
    'PGK',
    'LAK',
    'CZK',
    'SEK',
    'ISK',
    'DKK',
    'NOK',
    'HRK',
    'MWK',
    'ZMK',
    'AOA',
    'MMK',
    'GEL',
    'LVL',
    'ALL',
    'HNL',
    'SLL',
    'MDL',
    'RON',
    'BGN',
    'SZL',
    'TRY',
    'LTL',
    'LSL',
    'AZN',
    'BAM',
    'MZN',
    'NGN',
    'ERN',
    'BTN',
    'MRO',
    'MOP',
    'CUP',
    'CUC',
    'ARS',
    'CLF',
    'CLP',
    'COP',
    'DOP',
    'MXN',
    'PHP',
    'UYU',
    'FKP',
    'GIP',
    'SHP',
    'EGP',
    'LBP',
    'SDG',
    'SSP',
    'GBP',
    'SYP',
    'BWP',
    'GTQ',
    'ZAR',
    'BRL',
    'OMR',
    'QAR',
    'YER',
    'IRR',
    'KHR',
    'MYR',
    'SAR',
    'BYR',
    'RUB',
    'MUR',
    'SCR',
    'LKR',
    'NPR',
    'INR',
    'PKR',
    'IDR',
    'ILS',
    'KES',
    'SOS',
    'TZS',
    'UGX',
    'PEN',
    'KGS',
    'UZS',
    'TJS',
    'BDT',
    'WST',
    'KZT',
    'MNT',
    'VUV',
    'KPW',
    'KRW',
    'JPY',
    'CNY',
    'PLN',
    'MVR',
    'NLG',
    'ZMW',
    'ANG',
    'TMT',
  ];
}
