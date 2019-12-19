import 'dart:math';

import 'package:flutter/material.dart';

final RegExp lowerToUpper = RegExp('([a-z])([A-Z])');

String titleCase(String input) {
  if (input == '' || input == null) return input;
  input =
      input[0].toUpperCase() + input.substring(1); // capitalize first letter
  return input.replaceAllMapped(
      lowerToUpper, (m) => "${m[1]} ${m[2]}"); // space between words
}

String requiredValidator(String val) =>
    (val == null || val == "") ? "This field is required." : null;

String doubleValidator(String val) {
  if (val == null || val == "") return "This field is required.";
  try {
    double.parse(val);
  } catch (e) {
    return "Number";
  }
  return null;
}

String intNoRequire(String val) {
  if (val == null || val == "") return null;
  try {
    int.parse(val);
  } catch (e) {
    return "Integer";
  }
  return null;
}

String intValidator(String val) {
  if (val == null || val == "") return "This field is required.";
  return intNoRequire(val);
}

class RGB {
  double r = 0.0; // a fraction between 0 and 1
  double g = 0.0; // a fraction between 0 and 1
  double b = 0.0; // a fraction between 0 and 1

  toValue() {
    int red = (r * 255).toInt();
    int green = (g * 255).toInt();
    int blue = (b * 255).toInt();
    return (0xff << 24) + (red << 16) + (green << 8) + blue;
  }
}

class HSV {
  double h = 0.0; // angle in degrees
  double s = 0.0; // a fraction between 0 and 1
  double v = 0.0; // a fraction between 0 and 1

  HSV(this.h, this.s, this.v);

  toValue() => hsv2rgb(this).toValue();
}

HSV rgb2hsv(RGB rgb) {
  HSV out;
  double min, max, delta;

  min = rgb.r < rgb.g ? rgb.r : rgb.g;
  min = min < rgb.b ? min : rgb.b;

  max = rgb.r > rgb.g ? rgb.r : rgb.g;
  max = max > rgb.b ? max : rgb.b;

  out.v = max;
  delta = max - min;
  if (delta < 0.00001) {
    out.s = 0;
    out.h = 0; // undefined, maybe nan?
    return out;
  }
  if (max > 0.0) {
    // NOTE: if Max is == 0, this divide would cause a crash
    out.s = (delta / max);
  } else {
    // if max is 0, then r = g = b = 0
    // s = 0, h is undefined
    out.s = 0.0;
    out.h = double.infinity; // its now undefined
    return out;
  }

  if (rgb.r >= max) // > is bogus, just keeps compilor happy
    out.h = (rgb.g - rgb.b) / delta; // between yellow & magenta
  else if (rgb.g >= max)
    out.h = 2.0 + (rgb.b - rgb.r) / delta; // between cyan & yellow
  else
    out.h = 4.0 + (rgb.r - rgb.g) / delta; // between magenta & cyan

  out.h *= 60.0; // degrees

  if (out.h < 0.0) out.h += 360.0;

  return out;
}

RGB hsv2rgb(HSV hsv) {
  double hh, p, q, t, ff;
  int i;
  RGB out = RGB();

  if (hsv.s <= 0.0) {
    // < is bogus, just shuts up warnings
    out.r = hsv.v;
    out.g = hsv.v;
    out.b = hsv.v;
    return out;
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
      out.r = hsv.v;
      out.g = t;
      out.b = p;
      break;
    case 1:
      out.r = q;
      out.g = hsv.v;
      out.b = p;
      break;
    case 2:
      out.r = p;
      out.g = hsv.v;
      out.b = t;
      break;

    case 3:
      out.r = p;
      out.g = q;
      out.b = hsv.v;
      break;
    case 4:
      out.r = t;
      out.g = p;
      out.b = hsv.v;
      break;
    case 5:
    default:
      out.r = hsv.v;
      out.g = p;
      out.b = q;
      break;
  }
  return out;
}

clamp(input, lo, hi) {
  return (input < lo) ? lo : (input > hi) ? hi : input;
}

/// This will always round down for now
roundToDay(DateTime date) {
  var hours = Duration(hours: date.hour);
  var mins = Duration(minutes: date.minute);
  var secs = Duration(seconds: date.second);
  var millis = Duration(milliseconds: date.millisecond);
  return date.subtract(hours).subtract(mins).subtract(secs).subtract(millis);
}

double scaleToUnit(double _num, double _min, double _max) {
  if ((_max - _min).abs() < 0.001) {
    // don't want to be dividing by ~0, so we'll set the output to be green
    return 1.0;
  }
  return clamp((_num - _min) / (_max - _min), 0.0, 1.0);
}

double roundToPrecision(double val, int places){ 
  double mod = pow(10.0, places); 
  return ((val * mod).round().toDouble() / mod); 
}

changeFocus(FocusNode cur, FocusNode next) {
  cur.unfocus();
  next.requestFocus();
}
