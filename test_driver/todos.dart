import 'package:flutter_driver/flutter_driver.dart';

Future<void> newTodo(driver) async {
  // make sure we're on the home screen
  await driver.waitFor(find.byValueKey('__home_screen__'));
  print('home');
  await driver.waitFor(find.byValueKey('__fab__'));
  print('found button');
  await driver.tap(find.byValueKey('__main_fab__'));
  print('waiting on buttons');
  // await Future.delayed(Duration(milliseconds: 500));
  await driver.waitFor(find.byValueKey('new_todo_fab'));
  await driver.tap(find.byValueKey('new_todo_fab'));
  print('waiting for new todo screen');
  await driver.waitFor(find.byValueKey('__add_edit_todo__'));
}