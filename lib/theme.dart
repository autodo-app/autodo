import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import 'generated/localization.dart';

// Colors

/// Color palette generated from:
/// https://www.colorbox.io/#steps=9#hue_start=137#hue_end=190#hue_curve=easeInOutQuad#sat_start=5#sat_end=54#sat_curve=easeOutCubic#sat_rate=130#lum_start=100#lum_end=18#lum_curve=linear#minor_steps_map=0
const Map<int, Color> mainColors = {
  50: Color(0xffeefff3),
  100: Color(0xffd2fedf),
  200: Color(0xffb5fccc),
  300: Color(0xff86f3b2),
  400: Color(0xff64e2a9),
  500: Color(0xff4bc8a7),
  600: Color(0xff38a59d),
  700: Color(0xff28797e),
  800: Color(0xff1a4d55),
  900: Color(0xff0e292e),
};

// color used on logo: 77dea1

const MaterialColor mainPallette = MaterialColor(500, mainColors);

/// tag palette:
/// https://www.colorbox.io/#steps=11#hue_start=7#hue_end=140#hue_curve=easeInOutQuad#sat_start=47#sat_end=38#sat_curve=linear#sat_rate=130#lum_start=89#lum_end=53#lum_curve=easeOutSine#minor_steps_map=0
const Map<int, Color> tagColors = {
  50: Color(0xffe36d59),
  100: Color(0xffe2715b),
  200: Color(0xffe0845c),
  300: Color(0xffdba05d),
  400: Color(0xffd4c45c),
  500: Color(0xffaecb5b),
  600: Color(0xff7dbf58),
  700: Color(0xff59b154),
  800: Color(0xff4fa35c),
  900: Color(0xff4a955f),
};

const MaterialColor tagPallette = MaterialColor(500, tagColors);

const Color alertRed = Color(0xffce4c4c);
const Color warningOrange = Color(0xffdba05d);
const Color dividerGray = Color(0xbecccccc);
const Color emphasizedGray = Color(0xff777777);
const Color buttonGray = Color(0xffaaaaaa);

const Color textDark = Color(0xff444444);
const Color textLight = Color(0xffeeeeee);

final Color emphasizedButton = Colors.grey[500];

final Color cardColor =
    Color.lerp(mainPallette.shade900, Colors.grey[800], 0.7);
final Color bottomControllerColor =
    Color.lerp(mainPallette.shade900, Colors.grey[900], 0.7);

final grad1 = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [mainColors[300], mainColors[400]]);

final grad2 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [mainColors[700], mainColors[900]]);

final BoxDecoration headerDecoration =
    BoxDecoration(gradient: LinearGradient.lerp(grad1, grad2, 0.5));

//------------------------------------------------------------------------------
// Text Styles
//------------------------------------------------------------------------------

const TextStyle h1Dark = TextStyle(
    color: textDark,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    fontFamily: 'Ubuntu',
    letterSpacing: 0.2);
const TextStyle h2Dark = TextStyle(
    color: textDark,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    fontFamily: 'Ubuntu');
const TextStyle h3Dark = TextStyle(
    color: textDark,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: 'Ubuntu');
const TextStyle h4Dark = TextStyle(
    color: textDark,
    fontSize: 24,
    fontWeight: FontWeight.w300,
    fontFamily: 'Ubuntu');
const TextStyle h5Dark = TextStyle(
    color: textDark,
    fontSize: 20,
    fontWeight: FontWeight.w300,
    fontFamily: 'Ubuntu');
const TextStyle h6Dark = TextStyle(
  color: textDark,
  fontSize: 24,
  fontWeight: FontWeight.w500,
  fontFamily: 'Ubuntu',
  letterSpacing: 1.0,
);
const TextStyle body1Dark = TextStyle(
    color: textDark,
    fontSize: 18,
    fontWeight: FontWeight.w300,
    fontFamily: 'Ubuntu');
const TextStyle body2Dark = TextStyle(
    color: textDark,
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: 'Ubuntu');
const TextStyle s1Dark = TextStyle(
  color: textDark,
  fontSize: 20,
  fontWeight: FontWeight.w400,
  fontFamily: 'Ubuntu',
);
const TextStyle s2Dark = TextStyle(
  color: textDark,
  fontSize: 16,
  fontWeight: FontWeight.w400,
  fontFamily: 'Ubuntu',
);
const TextStyle buttonDark = TextStyle(
  color: textDark,
  fontSize: 14,
  fontWeight: FontWeight.w500,
  fontFamily: 'Ubuntu',
  letterSpacing: 0.2,
);
final emphasizedButtonDark = TextStyle(
    color: mainPallette.shade500,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Ubuntu',
    letterSpacing: 0.2);

const TextStyle h1Light = TextStyle(
  color: textLight,
  fontSize: 32,
  fontWeight: FontWeight.w800,
  fontFamily: 'Ubuntu',
  letterSpacing: 0.2,
);
const TextStyle h2Light = TextStyle(
    color: textLight,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    fontFamily: 'Ubuntu');
const TextStyle h3Light = TextStyle(
    color: textLight,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: 'Ubuntu');
const TextStyle h4Light = TextStyle(
    color: textLight,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontFamily: 'Ubuntu');
const TextStyle h5Light = TextStyle(
    color: textLight,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: 'Ubuntu');
const TextStyle h6Light = TextStyle(
  color: textLight,
  fontSize: 24,
  fontWeight: FontWeight.w500,
  fontFamily: 'Ubuntu',
  letterSpacing: 1.0,
);
const TextStyle body1Light = TextStyle(
    color: textLight,
    fontSize: 18,
    fontWeight: FontWeight.w300,
    fontFamily: 'Ubuntu');
const TextStyle body2Light = TextStyle(
    color: textLight,
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: 'Ubuntu');
const TextStyle s1Light = TextStyle(
  color: textLight,
  fontSize: 20,
  fontWeight: FontWeight.w400,
  fontFamily: 'Ubuntu',
);
const TextStyle s2Light = TextStyle(
  color: textLight,
  fontSize: 16,
  fontWeight: FontWeight.w400,
  fontFamily: 'Ubuntu',
);
const TextStyle buttonLight = TextStyle(
  color: textLight,
  fontSize: 14,
  fontWeight: FontWeight.w500,
  fontFamily: 'Ubuntu',
  letterSpacing: 0.2,
);
final emphasizedButtonLight = TextStyle(
    color: mainPallette.shade500,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Ubuntu',
    letterSpacing: 0.2);

Decoration scaffoldBackgroundGradient() {
  final blueGrey = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.blueGrey[200],
      Colors.blueGrey[700],
      Colors.blueGrey[700],
      Colors.blueGrey[700],
      Colors.blueGrey[900]
    ],
  );
  final darken = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.blueGrey[900], Colors.black87, Colors.black],
  );

  return BoxDecoration(
    gradient: LinearGradient.lerp(blueGrey, darken, 0.7),
  );
}

enum InputRule { none, required, optional }

InputDecoration defaultInputDecoration(
  BuildContext context,
  String label, {
  String unit,
  InputRule rule = InputRule.none,
  IconData icon,
  Widget button,
}) {
  return InputDecoration(
    hintText: rule == InputRule.required
        ? JsonIntl.of(context).get(IntlKeys.requiredLiteral)
        : rule == InputRule.optional
            ? JsonIntl.of(context).get(IntlKeys.optional)
            : null,
    suffixText: unit,
    prefix: button,
    hintStyle: body2Light,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: mainColors[500]),
    ),
    labelText: label,
    icon: icon == null
        ? null
        : Icon(
            icon,
            color: Colors.grey[300],
          ),
    labelStyle: body1Light,
    contentPadding:
        EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
  );
}

TextStyle linkStyle() {
  return TextStyle(
      decoration: TextDecoration.underline,
      decorationStyle: TextDecorationStyle.solid,
      fontSize: 13.0,
      fontWeight: FontWeight.w300);
}

TextStyle finePrint() {
  return TextStyle(fontSize: 13.0, fontWeight: FontWeight.w300);
}

ThemeData createTheme() {
  final primaryText = TextTheme(
      bodyText1: body1Light,
      bodyText2: body2Light,
      headline1: h1Light,
      headline2: h2Light,
      headline3: h3Light,
      headline4: h4Light,
      headline5: h5Light,
      headline6: h6Light,
      button: buttonLight,
      subtitle1: s1Light,
      subtitle2: s2Light,
      overline: emphasizedButtonLight);

  // Like the primary text theme, but dark.
  final accentTextTheme = TextTheme(
      bodyText1: body1Dark,
      bodyText2: body2Dark,
      headline1: h1Dark,
      headline2: h2Dark,
      headline3: h3Dark,
      headline4: h4Dark,
      headline5: h5Dark,
      headline6: h6Dark,
      button: buttonDark,
      subtitle1: s1Dark,
      subtitle2: s2Dark,
      overline: emphasizedButtonDark);

  return ThemeData(
    brightness: Brightness.dark,
    primarySwatch: mainPallette,
    primaryColor: mainPallette.shade500,
    primaryColorBrightness: Brightness.dark,
    primaryColorLight: mainPallette.shade400,
    primaryColorDark: mainPallette.shade600,
    accentColor: mainPallette.shade600, // same here
    accentColorBrightness: Brightness.dark,
    canvasColor: cardColor,
    scaffoldBackgroundColor: cardColor,
    cardColor: cardColor,
    dividerColor: Colors.white.withAlpha(200),
    focusColor: ThemeData.dark().focusColor,
    hoverColor: ThemeData.dark().hoverColor,
    highlightColor: ThemeData.dark().highlightColor,
    splashColor: ThemeData.dark().splashColor,
    splashFactory: ThemeData.dark().splashFactory,
    selectedRowColor: mainPallette.shade100, // check this
    unselectedWidgetColor: Colors.white.withAlpha(230), // check this
    disabledColor: Colors.grey,
    buttonColor: mainPallette.shade100,
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      colorScheme: ColorScheme(
        primary: mainPallette.shade500,
        onError: mainPallette.shade500,
        onBackground: mainPallette.shade500,
        onPrimary: mainPallette.shade500,
        onSecondary: mainPallette.shade500,
        onSurface: mainPallette.shade500,
        primaryVariant: mainPallette.shade500,
        brightness: Brightness.dark,
        surface: mainPallette.shade500,
        error: mainPallette.shade500,
        secondary: mainPallette.shade500,
        secondaryVariant: mainPallette.shade500,
        background: emphasizedButton,
      ),
    ),
    toggleButtonsTheme: ThemeData.fallback().toggleButtonsTheme, // same
    secondaryHeaderColor: mainPallette.shade300,
    textSelectionColor: mainPallette.shade400,
    cursorColor: mainPallette.shade300,
    textSelectionHandleColor: mainPallette.shade300,
    backgroundColor: cardColor,
    dialogBackgroundColor: cardColor,
    indicatorColor: mainPallette.shade700,
    hintColor: mainPallette.shade800,
    errorColor: alertRed,
    toggleableActiveColor: mainPallette.shade300,
    fontFamily: 'Ubuntu',
    textTheme: primaryText,
    primaryTextTheme: primaryText,
    accentTextTheme: accentTextTheme,
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: primaryText.bodyText2.copyWith(color: Colors.grey),
      labelStyle: primaryText.bodyText2,
      helperStyle: primaryText.bodyText2,
    ),
    iconTheme: IconThemeData(
      color: Colors.white.withAlpha(230),
    ),
    primaryIconTheme: IconThemeData(
      color: Colors.white.withAlpha(230),
    ),
    accentIconTheme: IconThemeData(
      color: Colors.black.withAlpha(230),
    ),
    // sliderTheme: ,
    // tabBarTheme: ,
    tooltipTheme: TooltipThemeData(
      textStyle: primaryText.headline6,
    ),
    // chipTheme: ,
    platform: TargetPlatform.android,
    materialTapTargetSize: ThemeData.fallback().materialTapTargetSize,
    applyElevationOverlayColor: false,
    // pageTransitionsTheme: ,
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      color: Colors.transparent,
      elevation: 0.0,
      iconTheme: ThemeData.dark().iconTheme,
      actionsIconTheme: ThemeData.dark().iconTheme,
      textTheme: primaryText,
    ),
    // bottomAppBarTheme: ,
    // colorScheme: prefix0.ColorScheme.fromSwatch(primarySwatch: mainPallette, ), // this sets a lot of defaults, avoiding for now
    dialogTheme: DialogTheme(
        backgroundColor: cardColor,
        titleTextStyle: primaryText.headline6,
        contentTextStyle: primaryText.bodyText2),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: mainPallette.shade500,
      foregroundColor: Colors.black.withAlpha(230),
    ),
    // TODO: snackbars are white right now for some reason
    // snackBarTheme: ,
    // bottomSheetTheme: ,
    // popupMenuTheme: ,
    bannerTheme:
        MaterialBannerThemeData(contentTextStyle: primaryText.headline6),
  );
}
