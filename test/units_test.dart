import 'package:autodo/units/efficiency.dart';
import 'package:autodo/units/units.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Distance Units', () {
    test('Default', () {
      expect(Distance.getDefault(Locale('en', 'US')), DistanceUnit.imperial);
      expect(Distance.getDefault(Locale('es', 'US')), DistanceUnit.imperial);
      expect(Distance.getDefault(Locale('en', 'CA')), DistanceUnit.metric);
      expect(Distance.getDefault(Locale('fr', 'CA')), DistanceUnit.metric);
      expect(Distance.getDefault(Locale('en', 'GB')), DistanceUnit.imperial);
    });

    test('Conversion', () {
      final locale = Locale('en', 'US');

      for (final unit in DistanceUnit.values) {
        final distance = Distance(unit, locale);

        for (final value in <double>[0, 1200, 45.4]) {
          {
            final displayValue = distance.internalToUnit(value);
            final internalValue = distance.unitToInternal(displayValue);
            expect(value, internalValue);
          }
          {
            final internalValue = distance.unitToInternal(value);
            final displayValue = distance.internalToUnit(internalValue);
            expect(value, displayValue);
          }
        }
      }
    });
  });

  group('Volume Units', () {
    test('Default', () {
      expect(Volume.getDefault(Locale('en', 'US')), VolumeUnit.us);
      expect(Volume.getDefault(Locale('es', 'US')), VolumeUnit.us);
      expect(Volume.getDefault(Locale('en', 'CA')), VolumeUnit.metric);
      expect(Volume.getDefault(Locale('fr', 'CA')), VolumeUnit.metric);
      expect(Volume.getDefault(Locale('en', 'GB')), VolumeUnit.imperial);
    });

    test('Conversion', () {
      final locale = Locale('en', 'US');

      for (final unit in VolumeUnit.values) {
        final distance = Volume(unit, locale);

        for (final value in <double>[0, 1200, 45.4]) {
          {
            final displayValue = distance.internalToUnit(value);
            final internalValue = distance.unitToInternal(displayValue);
            expect(value, internalValue);
          }
          {
            final internalValue = distance.unitToInternal(value);
            final displayValue = distance.internalToUnit(internalValue);
            expect(value, displayValue);
          }
        }
      }
    });
  });

  group('Efficiency Units', () {
    test('Default', () {
      expect(Efficiency.getDefault(Locale('en', 'US')), EfficiencyUnit.mpusg);
      expect(Efficiency.getDefault(Locale('es', 'US')), EfficiencyUnit.mpusg);
      expect(Efficiency.getDefault(Locale('en', 'CA')), EfficiencyUnit.lp100km);
      expect(Efficiency.getDefault(Locale('fr', 'CA')), EfficiencyUnit.lp100km);
      expect(Efficiency.getDefault(Locale('en', 'GB')), EfficiencyUnit.mpig);
    });

    test('Reflection', () {
      final locale = Locale('en', 'US');

      for (final unit in EfficiencyUnit.values) {
        final distance = Efficiency(unit, locale);

        for (final value in <double>[0, 1200, 45.4]) {
          {
            final displayValue = distance.internalToUnit(value);
            final internalValue = distance.unitToInternal(displayValue);
            expect(value.toStringAsFixed(4), internalValue.toStringAsFixed(4));
          }
          {
            final internalValue = distance.unitToInternal(value);
            final displayValue = distance.internalToUnit(internalValue);
            expect(value.toStringAsFixed(4), displayValue.toStringAsFixed(4));
          }
        }
      }
    });

    test('Conversion', () {
      final locale = Locale('en', 'US');

      expect(
        Efficiency(EfficiencyUnit.mpusg, locale)
            .unitToInternal(25.0)
            .toStringAsFixed(4),
        '10.6286',
      );

      expect(
        Efficiency(EfficiencyUnit.mpusg, locale)
            .internalToUnit(10.6286)
            .toStringAsFixed(4),
        '25.0000',
      );

      expect(
        Efficiency(EfficiencyUnit.mpig, locale)
            .unitToInternal(22.0)
            .toStringAsFixed(4),
        '7.7881',
      );

      expect(
        Efficiency(EfficiencyUnit.mpig, locale)
            .internalToUnit(7.7881)
            .toStringAsFixed(4),
        '21.9999',
      );

      expect(
        Efficiency(EfficiencyUnit.lp100km, locale)
            .unitToInternal(11.6)
            .toStringAsFixed(4),
        '8.6207',
      );

      expect(
        Efficiency(EfficiencyUnit.lp100km, locale)
            .internalToUnit(8.6207)
            .toStringAsFixed(4),
        '11.6000',
      );
    });
  });

  group('Currency', () {
    test('Default', () {
      expect(Currency.getDefault(Locale('en', 'US')), 'USD');
      expect(Currency.getDefault(Locale('es', 'US')), 'USD');
      expect(Currency.getDefault(Locale('en', 'CA')), 'CAD');
      expect(Currency.getDefault(Locale('fr', 'CA')), 'CAD');
      expect(Currency.getDefault(Locale('en', 'GB')), 'GBP');
      expect(Currency.getDefault(Locale('fr', 'FR')), 'EUR');
    });
  });
}
