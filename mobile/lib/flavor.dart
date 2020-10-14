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
        firebaseStorageUri: 'gs://autodo-49f21.appspot.com',
        restApiUrl: 'http://83d6495f6b44.ngrok.io',
        populateDemoData: true,
      );

/// Default release application settings
@immutable
class FlavorData {
  const FlavorData._({
    this.hasAds = false,
    this.hasPaid = true,
    this.useSentry = true,
    this.hasAnalytics = true,
    this.projectID = 'autodo-e93fc',
    this.googleAppIDiOS = '1:356275435347:ios:4e46f5fa8de51c6faad3a6',
    this.googleAppIDAndroid = '1:356275435347:android:5d33ed5a0494d852aad3a6',
    this.firebaseApiKey = Keys.firebaseProdKey,
    this.firebaseAppName = 'autodo-prod',
    this.firebaseStorageUri = 'gs://autodo-e93fc.appspot.com',
    this.restApiUrl = 'http://d406058d0db1.ngrok.io',
    this.populateDemoData = false,
  });

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

  /// URI for the Firebase Storage bucket
  final String firebaseStorageUri;

  /// URL for the REST API
  final String restApiUrl;

  /// Google Application ID
  String get googleAppID =>
      Platform.isIOS ? googleAppIDiOS : googleAppIDAndroid;

  /// Push Demo data on trial accounts
  final bool populateDemoData;
}
