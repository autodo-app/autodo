import 'dart:math';

final RegExp lowerToUpper = RegExp('([a-z])([A-Z])');

String titleCase(String input) {
  if (input == '' || input == null) return input;
  input = input[0].toUpperCase() + input.substring(1); // capitalize first letter
  return input.replaceAllMapped(lowerToUpper, (m) => "${m[1]} ${m[2]}"); // space between words
}

///
/// Translates a color in the HSL space to an RGB color as used by Flutter.
///
/// The input variables [h, s, l] should be in the space [0, 1].
/// 
/// The returned variables [r, g, b] are in the space [0, 255].
///
Map<String, int> hslToRgb(double h, double s, double l){
    var r, g, b;

    if (s == 0) {
        r = g = b = l; // achromatic
    } else {
      hue2rgb(p, q, t) {
        if(t < 0) t += 1;
        if(t > 1) t -= 1;
        if(t < 1/6) return p + (q - p) * 6 * t;
        if(t < 1/2) return q;
        if(t < 2/3) return p + (q - p) * (2/3 - t) * 6;
        return p;
      }

      var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      var p = 2 * l - q;
      r = hue2rgb(p, q, h + 1/3);
      g = hue2rgb(p, q, h);
      b = hue2rgb(p, q, h - 1/3);
    }

    return {
      "r": (r * 255).round(), 
      "g": (g * 255).round(), 
      "b": (b * 255).round()
    };
}

Map<String, double> rgb2Hsl(int r, int g, int b) {
    double _r = r / 255;
    double _g = g / 255;
    double _b = b / 255;
    var _max = max(_r, max(_g, _b));
    var _min = min(_r, min(_g, _b));

    var lum = (_max + _min) / 2;
    var hue, sat;
    if (max == min) {
        hue = 0;
        sat = 0;
    } else {
        var c = _max - _min; // chroma
        // saturation is simply the chroma scaled to fill
        // the interval [0, 1] for every combination of hue and lightness
        sat = c / (1 - (2 * lum - 1).abs());
        if (_max == _r)
          hue = (g - b) / c + (g < b ? 6 : 0);
        else if (_max == _g)
          hue = (b - r) / c + 2;
        else if (_max == _b)
          hue = (r - g) / c + 4;
    }
    hue /= 6;
    return {
      "h": hue,
      "s": sat,
      "l": lum,
    };
}

double scaleToUnit(double _num, double _min, double _max) {
  return (_num - _min) / (_max - _min);
}