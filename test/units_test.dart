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
