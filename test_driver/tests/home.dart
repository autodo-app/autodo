import 'package:flutter_driver/flutter_driver.dart';

Future<void> showRefuelingsTab(FlutterDriver driver) async {
  await driver.tap(find.byValueKey('__refuelings_tab_button__'));
}

Future<void> showRepeatsTab(FlutterDriver driver) async {
  await driver.tap(find.byValueKey('__repeats_tab_button__'));
}