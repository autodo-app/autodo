import 'package:firebase_admob/firebase_admob.dart';

class AutodoBannerAd extends BannerAd {
  AutodoBannerAd({adUnitId, size, targetingInfo, listener})
      : super(
            adUnitId: adUnitId ?? BannerAd.testAdUnitId,
            size: size ?? AdSize.banner,
            targetingInfo: targetingInfo ?? defaultTargetingInfo,
            listener: listener ?? defaultListener);

  static const String testDevice = 'Mobile_id';

  static const MobileAdTargetingInfo defaultTargetingInfo =
      MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['Game', 'Mario'],
  );

  static void defaultListener(MobileAdEvent event) {
    print('BannerAd $event');
  }
}
