import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:autodo/widgets/widgets.dart';

void main() {
  group('BannerAd', () {
    testWidgets('should render properly', (tester) async {
      Widget home = Scaffold(
        body: Container(),
      );
      Widget app = MaterialApp(
        home: home,
      );
      AutodoBannerAd()
        ..load()
        ..show();
      AutodoBannerAd.defaultListener(MobileAdEvent.loaded);
      await tester.pumpWidget(app);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
