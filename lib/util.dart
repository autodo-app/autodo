import 'dart:math';

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

final RegExp lowerToUpper = RegExp('([a-z])([A-Z])');

String titleCase(String input) {
  if (input == '' || input == null) return input;
  input =
      input[0].toUpperCase() + input.substring(1); // capitalize first letter
  return input.replaceAllMapped(
      lowerToUpper, (m) => '${m[1]} ${m[2]}'); // space between words
}

String requiredValidator(String val) =>
    (val == null || val == '') ? 'This field is required.' : null;

String doubleValidator(String val) {
  if (requiredValidator(val) != null) return requiredValidator(val);
  try {
    double.parse(val);
  } catch (e) {
    return 'Number';
  }
  return null;
}

String intNoRequire(String val) {
  if (val == null || val == '') return null;
  try {
    int.parse(val);
  } catch (e) {
    return 'Integer';
  }
  return null;
}

String intValidator(String val) {
  if (requiredValidator(val) != null) return requiredValidator(val);
  return intNoRequire(val);
}

class RGB extends Equatable {
  const RGB(this.r, this.g, this.b);

  /// a fraction between 0 and 1
  final double r;

  /// a fraction between 0 and 1
  final double g;

  /// a fraction between 0 and 1
  final double b;

  int toValue() {
    final red = (r * 255).toInt();
    final green = (g * 255).toInt();
    final blue = (b * 255).toInt();
    return (0xff << 24) + (red << 16) + (green << 8) + blue;
  }

  @override
  List<Object> get props => [r, g, b];

  @override
  String toString() => 'RGB { r: $r, g: $g, b: $b }';
}

class HSV extends Equatable {
  const HSV(this.h, this.s, this.v);

  /// angle in degrees
  final double h;

  /// a fraction between 0 and 1
  final double s;

  /// a fraction between 0 and 1
  final double v;

  int toValue() => hsv2rgb(this).toValue();

  @override
  List<Object> get props => [h, s, v];

  @override
  String toString() => 'HSV { h: $h, s: $s, v: $v }';
}

HSV rgb2hsv(RGB rgb) {
  double min, max, delta;

  min = rgb.r < rgb.g ? rgb.r : rgb.g;
  min = min < rgb.b ? min : rgb.b;

  max = rgb.r > rgb.g ? rgb.r : rgb.g;
  max = max > rgb.b ? max : rgb.b;

  double h, s;
  final v = max;

  delta = max - min;
  if (delta < 0.00001) {
    return HSV(v, 0, 0);
  }
  if (max > 0.0) {
    // NOTE: if Max is == 0, this divide would cause a crash
    s = delta / max;
  } else {
    // if max is 0, then r = g = b = 0
    // s = 0, h is undefined
    return HSV(double.infinity, 0.0, v);
  }

  if (rgb.r >= max) {
    // > is bogus, just keeps compiler happy
    h = (rgb.g - rgb.b) / delta; // between yellow & magenta
  } else if (rgb.g >= max) {
    h = 2.0 + (rgb.b - rgb.r) / delta; // between cyan & yellow
  } else {
    h = 4.0 + (rgb.r - rgb.g) / delta; // between magenta & cyan
  }

  h *= 60.0; // degrees

  if (h < 0.0) h += 360.0;

  return HSV(h, s, v);
}

RGB hsv2rgb(HSV hsv) {
  double hh, p, q, t, ff;
  int i;
  var out = RGB(0, 0, 0);

  if (hsv.s <= 0.0) {
    // < is bogus, just shuts up warnings
    return RGB(hsv.v, hsv.v, hsv.v);
  }
  hh = hsv.h;
  if (hh >= 360.0) hh = 0.0;
  hh /= 60.0;
  i = hh.toInt();
  ff = hh - i;
  p = hsv.v * (1.0 - hsv.s);
  q = hsv.v * (1.0 - (hsv.s * ff));
  t = hsv.v * (1.0 - (hsv.s * (1.0 - ff)));

  switch (i) {
    case 0:
      out = RGB(hsv.v, t, p);
      break;
    case 1:
      out = RGB(q, hsv.v, p);
      break;
    case 2:
      out = RGB(p, hsv.v, t);
      break;
    case 3:
      out = RGB(p, q, hsv.v);
      break;
    case 4:
      out = RGB(t, p, hsv.v);
      break;
    case 5:
    default:
      out = RGB(hsv.v, p, q);
      break;
  }
  return out;
}

num clamp(num input, num lo, num hi) {
  return (input < lo) ? lo : (input > hi) ? hi : input;
}

/// This will always round down for now
DateTime roundToDay(DateTime date) {
  final hours = Duration(hours: date.hour);
  final mins = Duration(minutes: date.minute);
  final secs = Duration(seconds: date.second);
  final millis = Duration(milliseconds: date.millisecond);
  return date.subtract(hours).subtract(mins).subtract(secs).subtract(millis);
}

double scaleToUnit(double _num, double _min, double _max) {
  if ((_max - _min).abs() < 0.001) {
    // don't want to be dividing by ~0, so we'll set the output to be green
    return 1.0;
  }
  return clamp((_num - _min) / (_max - _min), 0.0, 1.0);
}

double roundToPrecision(double val, int places) {
  final double mod = pow(10.0, places);
  return (val * mod).round().toDouble() / mod;
}

void changeFocus(FocusNode cur, FocusNode next) {
  cur.unfocus();
  next.requestFocus();
}
