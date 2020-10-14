import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'generated/env.dart';

/// This allows to configure some features that will not change during
/// the app life
const kFlavor = kReleaseMode
    ? FlavorData._()
    : // Debug mode settings
    FlavorData._(
        hasPaid: false,
        useSentry: false,
        hasAnalytics: false,
        restApiUrl: Env.apiUrl,
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

  /// URL for the REST API
  final String restApiUrl;

  /// Push Demo data on trial accounts
  final bool populateDemoData;
}
