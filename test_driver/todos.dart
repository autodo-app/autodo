import 'package:flutter_driver/flutter_driver.dart';

/// Creates a new, standalone todo (not connected to a repeat)
Future<void> newTodo(driver) async {
  // make sure we're on the home screen
  await driver.waitFor(find.byValueKey('__home_screen__'));
  print('home');
  await driver.waitFor(find.byValueKey('__fab__'));
  print('found button');
  await driver.tap(find.byValueKey('__main_fab__'));
  print('waiting on buttons');
  await driver.waitFor(find.byValueKey('new_todo_fab'));
  await driver.tap(find.byValueKey('new_todo_fab'));
  
  print('waiting for new todo screen');
  await driver.waitFor(find.byValueKey('__add_edit_todo__'));
  await driver.tap(find.byType('_NameForm'));
  await driver.enterText('test todo');
  await driver.tap(find.byType('_DateForm'));
  await driver.enterText('01/01/2020');
  await driver.tap(find.byType('_MileageForm'));
  await driver.enterText('2000');
  await driver.tap(find.byValueKey('__todo_car_form__'));
  await driver.enterText('test');
  
  // submit
  await driver.tap(find.byType('FloatingActionButton'));
  await driver.waitFor(find.byValueKey('__home_screen__'));

  await Future.delayed(Duration(seconds: 10));
  // check to see that the todo is placed in the queue?
}