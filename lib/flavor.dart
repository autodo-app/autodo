import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// This allows to configure some features that will not change during
/// the app life
const kFlavor = kReleaseMode
    ? FlavorData._()
    : // Debug mode settings
    FlavorData._(
        hasPaid: false,
      );

/// Default release application settings
@immutable
class FlavorData {
  const FlavorData._({
    this.hasAds = false,
    this.hasPaid = true,
  });

  final bool hasAds;

  final bool hasPaid;
}
