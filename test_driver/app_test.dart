import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'tests/barrel.dart';

void main() {
  group('new user', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver?.close();
    });

    test('sign up a new user', () async => await signUp(driver));
    test('new todo', () async => await newTodo(driver));
    test('complete todo', () async => await completeTodo(driver));
    test('edit todo', () async => await editTodo(driver));
    test('delete todo', () async => await deleteTodo(driver));
    test('sign out', () async => await signOut(driver));
    test('sign back in', () async => await signIn(driver));
    // end the test by deleting the test user that we created
    test('delete user', () async => await deleteUser(driver));
  });
}