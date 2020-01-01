import 'package:flutter_driver/flutter_driver.dart';

/// Creates a new refueling
Future<void> newRepeat(driver) async {
  // make sure we're on the home screen
  await driver.waitFor(find.byValueKey('__home_screen__'));
  print('home');
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