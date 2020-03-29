import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'generated/keys.dart';

/// This allows to configure some features that will not change during
/// the app life
const kFlavor = kReleaseMode
    ? FlavorData._()
    : // Debug mode settings
    FlavorData._(
        hasPaid: false,
        useSentry: false,
        hasAnalytics: false,
        projectID: 'autodo-49f21',
        googleAppIDiOS: '1:617460744396:ios:7da25d96edce10cefc4269',
        googleAppIDAndroid: '1:617460744396:android:400cbb86de167047',
        firebaseApiKey: Keys.firebaseTestKey,
        firebaseAppName: 'autodo',
      );

/// Default release application settings
@immutable
class FlavorData {
  const FlavorData._(
      {this.hasAds = false,
      this.hasPaid = true,
      this.useSentry = true,
      this.hasAnalytics = true,
      this.projectID = 'autodo-e93fc',
      this.googleAppIDiOS = '1:356275435347:ios:4e46f5fa8de51c6faad3a6',
      this.googleAppIDAndroid = '1:356275435347:android:5d33ed5a0494d852aad3a6',
      this.firebaseApiKey = Keys.firebaseProdKey,
      this.firebaseAppName = 'autodo-prod'});

  /// Enable the Ads banner
  final bool hasAds;

  /// Shows an in-app buy button to upgrade to the premium version
  final bool hasPaid;

  /// Send the runtime errors to Sentry
  final bool useSentry;

  /// Add analytics to the app
  final bool hasAnalytics;

  /// Firebase Project ID
  final String projectID;

  /// Google App ID for iOS
  final String googleAppIDiOS;

  /// Google App ID for Android
  final String googleAppIDAndroid;

  /// Firebase Private Api Key
  final String firebaseApiKey;

  /// Firebase application name
  final String firebaseAppName;

  /// Google Application ID
  String get googleAppID =>
      Platform.isIOS ? googleAppIDiOS : googleAppIDAndroid;
}
