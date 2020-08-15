import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/util.dart';

void main() {
  group('Util', () {
    test('titleCase', () {
      expect(titleCase('all lowercase text'), 'All lowercase text');
    });
    group('required', () {
      test('null', () {
        expect(requiredValidator(null), 'This field is required.');
      });
      test('empty', () {
        expect(requiredValidator(''), 'This field is required.');
      });
      test('pass', () {
        expect(requiredValidator('test'), null);
      });
    });
    group('double', () {
      test('str', () {
        expect(doubleValidator('test'), 'Number');
      });
      test('empty', () {
        expect(doubleValidator(''), 'This field is required.');
      });
      test('pass', () {
        expect(doubleValidator('1.0'), null);
      });
    });
    group('int no req', () {
      test('str', () {
        expect(intNoRequire('test'), 'Integer');
      });
      test('pass', () {
        expect(intNoRequire('1'), null);
      });
    });
    group('int', () {
      test('empty', () {
        expect(intValidator(''), 'This field is required.');
      });
      test('pass', () {
        expect(intValidator('1'), null);
      });
    });
    group('hsv2rgb', () {
      test('no sat', () {
        expect(hsv2rgb(HSV(1.0, 0.0, 1.0)), RGB(1.0, 1.0, 1.0));
      });
      test('1', () {
        expect(hsv2rgb(HSV(60.0, 1.0, 1.0)), RGB(1.0, 1.0, 0.0));
      });
      test('2', () {
        expect(hsv2rgb(HSV(120.0, 1.0, 1.0)), RGB(0.0, 1.0, 0.0));
      });
      test('3', () {
        expect(hsv2rgb(HSV(180.0, 1.0, 1.0)), RGB(0.0, 1.0, 1.0));
      });
      test('4', () {
        expect(hsv2rgb(HSV(240.0, 1.0, 1.0)), RGB(0.0, 0.0, 1.0));
      });
      test('5', () {
        expect(hsv2rgb(HSV(300.0, 1.0, 1.0)), RGB(1.0, 0.0, 1.0));
      });
    });
    group('rgb2hsv', () {
      test('1', () {
        expect(rgb2hsv(RGB(1.0, 0.0, 0.0)), HSV(0.0, 1.0, 1.0));
      });
      test('2', () {
        expect(rgb2hsv(RGB(1.0, 1.0, 0.0)), HSV(60.0, 1.0, 1.0));
      });
      test('3', () {
        expect(rgb2hsv(RGB(0.0, 1.0, 0.0)), HSV(120.0, 1.0, 1.0));
      });
      test('4', () {
        expect(rgb2hsv(RGB(0.0, 1.0, 1.0)), HSV(180.0, 1.0, 1.0));
      });
      test('5', () {
        expect(rgb2hsv(RGB(0.0, 0.0, 1.0)), HSV(240.0, 1.0, 1.0));
      });
      test('6', () {
        expect(rgb2hsv(RGB(1.0, 0.0, 1.0)), HSV(300.0, 1.0, 1.0));
      });
      test('7', () {
        expect(rgb2hsv(RGB(0.0, 0.0, 0.0)), HSV(0.0, 0.0, 0.0));
      });
      test('8', () {
        expect(rgb2hsv(RGB(1.0, 1.0, 1.0)), HSV(1.0, 0.0, 0.0));
      });
      test('9', () {
        expect(rgb2hsv(RGB(-1.0, -3.0, -2.0)), HSV(double.infinity, 0.0, -1.0));
      });
    });
    group('scale', () {
      test('small', () {
        expect(scaleToUnit(1.0, 0.0, 0.0), 1.0);
      });
      test('normal', () {
        expect(scaleToUnit(2.0, 0.0, 4.0), 0.5);
      });
    });
    test('rgb toString', () {
      expect(
          RGB(
            0,
            0,
            0,
          ).toString(),
          'RGB { r: 0.0, g: 0.0, b: 0.0 }');
    });
    test('hsv toString', () {
      expect(
          HSV(
            0,
            0,
            0,
          ).toString(),
          'HSV { h: 0.0, s: 0.0, v: 0.0 }');
    });
    test('roundToPrecision', () {
      expect(roundToPrecision(10.111, 2), 10.11);
      expect(roundToPrecision(10.1, 2), 10.1);
    });
  });
}
