import 'package:flutter_driver/flutter_driver.dart';

Future<void> checkForDefaults(FlutterDriver driver) async {
  // find each of the default repeats
  print('scrolling');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_oil'), dyScroll: -10.0);
  print('oil found');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_tireRotation'), dyScroll: -10.0);
  print('rot found');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_wiperBlades'), dyScroll: -10.0);
  print('wiper found');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_alignmentCheck'), dyScroll: -10.0);
  print('align found');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_cabinFilter'), dyScroll: -10.0);
  print('cab found');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_engineFilter'), dyScroll: -10.0);
  print('eng found');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_tires'), dyScroll: -10.0);
  print('tire found');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_brakes'), dyScroll: -10.0);
  print('brak found');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_sparkPlugs'), dyScroll: -10.0);
  print('spark found');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_battery'), dyScroll: -10.0);
  print('bat found');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_frontStruts'), dyScroll: -10.0);
  print('front found');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_rearStruts'), dyScroll: -10.0);
  print('rear found');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_coolantChange'), dyScroll: -10.0);
  print('cool found');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_transmissionFluid'), dyScroll: -10.0);
  print('trans found');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_serpentineBelt'), dyScroll: -10.0);
  print('belt found');
}

/// Creates a new refueling
Future<void> newRepeat(driver) async {
  await driver.waitFor(find.byValueKey('__fab__'));
  print('found button');
  await driver.tap(find.byValueKey('__main_fab__'));
  print('waiting on buttons');
  await driver.waitFor(find.byValueKey('new_repeat_fab'));
  await driver.tap(find.byValueKey('new_repeat_fab'));
  
  print('waiting for new repeat screen');
  await driver.waitFor(find.byValueKey('__add_edit_repeat__'));
  await driver.tap(find.byType('_MileageForm'));
  await driver.enterText('2000');
  
  // submit
  await driver.tap(find.byType('FloatingActionButton'));
  print('waiting to be on the home screen again');
  await driver.waitFor(find.byValueKey('__repeats_screen_scroller__'));
}

/// Edits the previously created Refueling
Future<void> editRepeat(FlutterDriver driver) async {
  // edit button
  print('scrolling');
  await driver.scrollUntilVisible(find.byValueKey('__repeats_screen_scroller__'), find.byValueKey('__repeat_card_edit_test'), dyScroll: -100.0);
  print('tapping');
  await driver.tap(find.byValueKey('__repeat_card_edit_test'));

  // edit screen
  await driver.waitFor(find.byType('RepeatAddEditScreen'));
  await driver.tap(find.byType('_MileageForm'));
  await driver.enterText('3000');
  await driver.tap(find.byType('FloatingActionButton'));

  // check that we returned to home screen
  await driver.waitFor(find.byValueKey('__repeat_screen_scroller__'));
} 

/// Deletes the newly created todo from the home screen
Future<void> deleteRepeat(FlutterDriver driver) async {
  // press button
  print('scrolling');
  await driver.scrollUntilVisible(find.byValueKey('__repeat_screen_scroller__'), find.byValueKey('__repeat_delete_button_test_3000'), dyScroll: -100.0);
  print('tapping');
  await driver.tap(find.byValueKey('__repeat_delete_button_test'));

  // verify that the card no longer exists
  await driver.waitForAbsent(find.byValueKey('__repeat_card_edit_test'));
}