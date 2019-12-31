import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'todos.dart';

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

    test('sign up a new user', () async {
      // Welcome Screen
      await driver.waitFor(find.byValueKey('__welcome_screen__'), timeout: Duration(minutes: 2));
      await driver.tap(find.byType("SignupButton"));
      print('Welcome Screen completed');

      // Enter email and password into signup screen
      await driver.waitFor(find.byValueKey('__signup_screen__'));
      await driver.enterText('integration-test@autodo.app');
      await driver.tap(find.byType('PasswordForm'));
      await driver.enterText('123456');
      await Future.delayed(Duration(milliseconds: 500));
      await driver.tap(find.byType('SignupSubmitButton'));
      print('Signup Screen Completed');

      // mileage setting screen
      await Future.delayed(Duration(milliseconds: 500));
      await driver.waitFor(find.byType('MileageScreen'), timeout: Duration(minutes: 1));
      await driver.tap(find.byValueKey('__mileage_name_field__'));
      await driver.enterText('test');
      await driver.tap(find.byValueKey('__mileage_mileage_field__'));
      await driver.enterText('1000');
      await driver.tap(find.byValueKey('__mileage_next_button__'));
      print('mileage setting screen completed');
      
      // last completed todo screen
      await driver.waitFor(find.byType('LatestRepeatsScreen'));
      await driver.tap(find.byValueKey('__latest_oil_change_field__'));
      await driver.enterText('500');
      await driver.tap(find.byValueKey('__latest_tire_rotation_field__'));
      await driver.enterText('500');
      await driver.tap(find.byValueKey('__latest_next_button__'));
      print('latest completed repeats screen completed');

      // interval screen
      await driver.waitFor(find.byType('SetRepeatsScreen'));
      await driver.tap(find.byValueKey('__set_oil_interval__'));
      await driver.enterText('5000');
      await driver.tap(find.byValueKey('__set_tire_rotation_interval__'));
      await driver.enterText('20000');
      await driver.tap(find.byValueKey('__set_repeats_next__'));
      print('set repeats interval screen completed');

      // expect that we will hit the home page
      await Future.delayed(Duration(milliseconds: 500));
      await driver.waitFor(find.byValueKey('__home_screen__'));
    });

    test('new todo', () async => await newTodo(driver));
    test('complete todo', () async => await completeTodo(driver));
    test('edit todo', () async => await editTodo(driver));
    test('delete todo', () async => await deleteTodo(driver));
  });
}