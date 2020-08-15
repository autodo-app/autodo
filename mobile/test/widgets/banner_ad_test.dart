import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:autodo/widgets/widgets.dart';

void main() {
  group('BannerAd', () {
    testWidgets('should render properly', (tester) async {
      final Widget home = Scaffold(
        body: Container(),
      );
      final Widget app = MaterialApp(
        home: home,
      );
      final bannerAd = AutodoBannerAd();
      // ignore: unawaited_futures
      bannerAd.load().then((value) => bannerAd.show());
      AutodoBannerAd.defaultListener(MobileAdEvent.loaded);
      await tester.pumpWidget(app);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
