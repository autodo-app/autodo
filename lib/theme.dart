import 'package:flutter/material.dart';

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

const Color errorColor = Color(0xffcf6679);
final Color cardColor =
    Color.lerp(mainPallette.shade900, Colors.grey[800], 0.7);
final Color bottomControllerColor =
    Color.lerp(mainPallette.shade900, Colors.grey[900], 0.7);

const splashColor = Color(0xff454f51);

Decoration scaffoldBackgroundGradient() {
  LinearGradient blueGrey = LinearGradient(
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
  LinearGradient darken = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.blueGrey[900], Colors.black87, Colors.black],
  );
  BoxDecoration bgGradient() {
    return BoxDecoration(
      gradient: LinearGradient.lerp(blueGrey, darken, 0.7),
    );
  }

  return bgGradient();
}

TextStyle logoStyle = TextStyle(
  color: Colors.white.withAlpha(230),
  fontSize: 24,
  fontWeight: FontWeight.w800,
  fontFamily: 'Ubuntu',
  letterSpacing: 0.2,
);

InputDecoration defaultInputDecoration(String hintText, String labelText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white.withAlpha(230),
      fontSize: 16,
      fontWeight: FontWeight.w300,
      fontFamily: 'IBM Plex Sans',
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.teal),
    ),
    labelText: labelText,
    labelStyle: TextStyle(
      color: Colors.white.withAlpha(230),
      fontFamily: 'IBM Plex Sans',
      fontWeight: FontWeight.w300,
      fontSize: 18,
    ),
    contentPadding:
        EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
  );
}

createTheme() {
  TextTheme primaryText = TextTheme(
    body1: TextStyle(
      color: Colors.white.withAlpha(230),
      fontSize: 16,
      fontWeight: FontWeight.w300,
      fontFamily: 'IBM Plex Sans',
    ),
    button: TextStyle(
      color: Colors.white.withAlpha(230),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: 'IBM Plex Sans',
      letterSpacing: 0.2,
    ),
    display1: TextStyle(
      fontSize: 30,
      fontFamily: 'Ubuntu',
      fontWeight: FontWeight.w600,
      color: Colors.white.withAlpha(230),
    ),
    title: TextStyle(
      color: Colors.white.withAlpha(230),
      fontSize: 24,
      fontWeight: FontWeight.w500,
      fontFamily: 'IBM Plex Sans',
      letterSpacing: 1.0,
    ),
    subtitle: TextStyle(
      color: Colors.white.withAlpha(230),
      fontSize: 18,
      fontWeight: FontWeight.w400,
      fontFamily: 'IBM Plex Sans',
    ),
  );

  // Like the primary text theme, but dark.
  TextTheme accentTextTheme = TextTheme(
    button: TextStyle(
      color: Colors.black.withAlpha(230),
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontFamily: 'IBM Plex Sans',
      letterSpacing: 0.2,
    ),
    body2: TextStyle(
      // This is used for the car tags
      color: Colors.black.withAlpha(230),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: 'IBM Plex Sans',
      letterSpacing: 0.2,
    ),
  );

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
      buttonColor: Colors.white.withAlpha(230),
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
    errorColor: errorColor,
    toggleableActiveColor: mainPallette.shade300,
    fontFamily: 'IBM Plex Sans',
    textTheme: primaryText,
    primaryTextTheme: primaryText,
    accentTextTheme: accentTextTheme,
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: primaryText.body1.copyWith(color: Colors.grey),
      labelStyle: primaryText.body1,
      helperStyle: primaryText.body1,
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
      textStyle: primaryText.title,
    ),
    // chipTheme: ,
    platform: TargetPlatform.android,
    materialTapTargetSize: ThemeData.fallback().materialTapTargetSize,
    // applyElevationOverlayColor: true, // used with dark themes to add elevation status, check this
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
        titleTextStyle: primaryText.title,
        contentTextStyle: primaryText.body1),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: mainPallette.shade500,
      foregroundColor: Colors.black.withAlpha(230),
    ),
    // TODO: snackbars are white right now for some reason
    // snackBarTheme: ,
    // bottomSheetTheme: ,
    // popupMenuTheme: ,
    bannerTheme: MaterialBannerThemeData(contentTextStyle: primaryText.title),
  );
}
