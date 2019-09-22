import 'package:flutter/material.dart';

/// Color palette generated from:
/// https://www.colorbox.io/#steps=9#hue_start=137#hue_end=190#hue_curve=easeInOutQuad#sat_start=5#sat_end=54#sat_curve=easeOutCubic#sat_rate=130#lum_start=100#lum_end=18#lum_curve=linear#minor_steps_map=0
const Map<int, Color> mainColors =
{
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

const MaterialColor mainPallette = MaterialColor(500, mainColors);

/// tag palette:
/// https://www.colorbox.io/#steps=11#hue_start=7#hue_end=140#hue_curve=easeInOutQuad#sat_start=47#sat_end=38#sat_curve=linear#sat_rate=130#lum_start=89#lum_end=53#lum_curve=easeOutSine#minor_steps_map=0
Map<String, Color> tagPallette =
{
    "0": Color(0xffe36858),
    "5": Color(0xffe36d59),
    "10": Color(0xffe2715b),
    "20": Color(0xffe0845c),
    "30": Color(0xffdba05d),
    "40": Color(0xffd4c45c),
    "50": Color(0xffaecb5b),
    "60": Color(0xff7dbf58),
    "70": Color(0xff59b154),
    "80": Color(0xff4fa35c),
    "90": Color(0xff4a955f),
    "100": Color(0xff44875b)
};

const Color errorColor = Color(0xffcf6679);

Decoration scaffoldBackgroundGradient() {
  LinearGradient blueGrey = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    // colors: [Colors.blueGrey[200], Colors.blueGrey[800]],
    colors: [mainPallette.shade700, mainPallette.shade900, mainPallette.shade900, Colors.black],
  );
  BoxDecoration bgGradient() {
    return BoxDecoration(
      // gradient: LinearGradient.lerp(blueGrey, blue, 0.4),
      gradient: blueGrey,
    );
  }
  return bgGradient();
}

TextTheme primaryTextTheme = TextTheme(  
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

ThemeData theme = ThemeData( 
  brightness: Brightness.dark,
  primarySwatch: mainPallette,
  primaryColor: mainPallette.shade500, // one darker than before
  primaryColorBrightness: Brightness.light,
  primaryColorLight: mainPallette.shade300,
  primaryColorDark: mainPallette.shade500,
  accentColor: mainPallette.shade600, // same here 
  accentColorBrightness: Brightness.light,
  canvasColor: mainPallette.shade900,
  scaffoldBackgroundColor: mainPallette.shade900,
  bottomAppBarColor: mainPallette.shade800,
  cardColor: mainPallette.shade800,
  dividerColor: ThemeData.fallback().dividerColor,
  focusColor: ThemeData.fallback().focusColor,
  hoverColor: ThemeData.fallback().hoverColor,
  highlightColor: ThemeData.fallback().highlightColor,
  splashColor: ThemeData.fallback().splashColor,
  splashFactory: ThemeData.fallback().splashFactory,
  selectedRowColor: mainPallette.shade100, // check this
  unselectedWidgetColor: mainPallette.shade200, // check this
  disabledColor: mainPallette.shade200,
  buttonColor: mainPallette.shade100,
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.white.withAlpha(230),
  ),
  toggleButtonsTheme: ThemeData.fallback().toggleButtonsTheme, // same
  secondaryHeaderColor: mainPallette.shade300,
  textSelectionColor: mainPallette.shade400,
  cursorColor: mainPallette.shade300,
  textSelectionHandleColor: mainPallette.shade300,
  backgroundColor: mainPallette.shade900,
  dialogBackgroundColor: mainPallette.shade800,
  indicatorColor: mainPallette.shade700,
  hintColor: mainPallette.shade800,
  errorColor: errorColor,
  toggleableActiveColor: mainPallette.shade300,
  fontFamily: 'IBM Plex Sans',
  // textTheme: ,
  primaryTextTheme: primaryTextTheme,
  // accentTextTheme: ,
  // inputDecorationTheme: ,
  iconTheme: IconThemeData(
    color: Colors.white.withAlpha(230),
  ),
  primaryIconTheme: IconThemeData(  
    color: Colors.white.withAlpha(230),
  ),
  // accentIconTheme: ,
  // sliderTheme: ,
  // tabBarTheme: ,
  // tooltipTheme: ,
  // cardTheme: ,
  // chipTheme: ,
  platform: TargetPlatform.android,
  materialTapTargetSize: ThemeData.fallback().materialTapTargetSize,
  applyElevationOverlayColor: true, // used with dark themes to add elevation status, check this
  // applyElevationOverlayColor: false,
  // pageTransitionsTheme: ,
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark, 
    color: Colors.transparent, 
    elevation: 0.0, 
    iconTheme: ThemeData.dark().iconTheme,
    actionsIconTheme: ThemeData.dark().iconTheme, 
    textTheme: primaryTextTheme,
  ),
  // bottomAppBarTheme: ,
  // colorScheme: prefix0.ColorScheme.fromSwatch(primarySwatch: mainPallette, ), // this sets a lot of defaults, avoiding for now
  // dialogTheme: ,
  // floatingActionButtonTheme: ,
  // typography: Typography(
  //   platform: TargetPlatform.android, black: Typography.blackCupertino, white: Typography.whiteCupertino,
  // ),
  // snackBarTheme: ,
  // bottomSheetTheme: ,
  // popupMenuTheme: ,
  // bannerTheme: ,
  dividerTheme: DividerThemeData(  
    color: Colors.white24,
  ), 
);