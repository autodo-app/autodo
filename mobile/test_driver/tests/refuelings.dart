import 'package:flutter_driver/flutter_driver.dart';

import 'package:intl/intl.dart';

/// Creates a new refueling
Future<void> newRefueling(FlutterDriver driver) async {
  // make sure we're on the home screen
  await driver.waitFor(find.byValueKey('__home_screen__'));
  print('home');
  await driver.waitFor(find.byValueKey('__fab__'));
  print('found button');
  await driver.tap(find.byValueKey('__main_fab__'));
  print('waiting on buttons');
  await driver.waitFor(find.byValueKey('new_refueling_fab'));
  await driver.tap(find.byValueKey('new_refueling_fab'));

  print('waiting for new refueling screen');
  await driver.waitFor(find.byValueKey('__add_edit_refueling__'));
  await driver.tap(find.byType('_MileageForm'));
  await driver.enterText('2000');
  // await driver.tap(find.byValueKey('__refueling_car_form__'));
  // await driver.enterText('test');
  await driver.tap(find.byType('_CostForm'));
  await driver.enterText('20');
  await driver.tap(find.byType('_AmountForm'));
  await driver.enterText('20');
  await driver.tap(find.byType('_DateForm'));
  final today = DateTime.now();
  final yesterday = today.subtract(Duration(days: 1));
  await driver.enterText(DateFormat.yMd().format(yesterday));

  // submit
  await driver.tap(find.byType('FloatingActionButton'));
  print('waiting to be on the home screen again');
  await driver.waitFor(find.byValueKey('__refuelings_screen_scroller__'));

  // check to see that the todo is placed in the queue?
}

/// Edits the previously created Refueling
Future<void> editRefueling(FlutterDriver driver) async {
  // edit button
  print('scrolling');
  await driver.scrollUntilVisible(
      find.byValueKey('__refuelings_screen_scroller__'),
      find.byValueKey('__refueling_card_edit_test_${2000 * 1.609344}'),
      dyScroll: -100.0);
  print('tapping');
  await driver
      .tap(find.byValueKey('__refueling_card_edit_test_${2000 * 1.609344}'));

  // edit screen
  await driver.waitFor(find.byType('RefuelingAddEditScreen'));
  await driver.tap(find.byType('_MileageForm'));
  await driver.enterText('3000');
  await driver.tap(find.byType('FloatingActionButton'));

  // check that we returned to home screen
  await driver.waitFor(find.byValueKey('__refuelings_screen_scroller__'));
}

/// Deletes the newly created todo from the home screen
Future<void> deleteRefueling(FlutterDriver driver) async {
  // press button
  print('scrolling');
  await driver.scrollUntilVisible(
      find.byValueKey('__refuelings_screen_scroller__'),
      find.byValueKey('__refueling_delete_button_test_${3000 * 1.609344}'),
      dyScroll: -100.0);
  print('tapping');
  await driver.tap(
      find.byValueKey('__refueling_delete_button_test_${3000 * 1.609344}'));

  // verify that the card no longer exists
  await driver.waitForAbsent(
      find.byValueKey('__refueling_card_edit_test_${3000 * 1.609344}'));
}
