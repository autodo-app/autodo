import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'tests/barrel.dart';

void main() {
  group('server user', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      // wait for the welcome screen to appear before we start running tests
      await driver.waitFor(find.byValueKey('__welcome_screen__'),
          timeout: Duration(minutes: 5));
    });

    // Close the connection to the driver after the tests have completed.
    // tearDownAll(() async {
    //   driver?.close();
    // });

    test('sign up a new user', () async => await signUp(driver));
    // Todos
    test('new todo', () async => await newTodo(driver));
    test('complete todo', () async => await completeTodo(driver));
    test('edit todo', () async => await editTodo(driver));
    test('delete todo', () async => await deleteTodo(driver));

    // Refuelings
    test('switch to refuelings tab',
        () async => await showRefuelingsTab(driver));
    test('new refueling', () async => await newRefueling(driver));
    test('edit refueling', () async => await editRefueling(driver));
    test('delete refueling', () async => await deleteRefueling(driver));

    // // Repeats
    // test('switch to repeats tab', () async => await showRepeatsTab(driver));
    // test('check for defaults', () async => await checkForDefaults(driver));
    // test('new repeat', () async => await newRepeat(driver));
    // test('edit repeat', () async => await editRepeat(driver));
    // test('delete repeat', () async => await deleteRepeat(driver));

    // last auth tests
    test('sign out', () async => await signOut(driver));
    test('sign back in', () async => await signIn(driver));
    // end the test by deleting the test user that we created
    test('delete user', () async => await deleteUser(driver));
  });
  group('local user', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    // tearDownAll(() async {
    //   await driver?.close();
    // });

    test('start trial', () async => await startTrial(driver));
    // Todos
    test('new todo', () async => await newTodo(driver));
    test('complete todo', () async => await completeTodo(driver));
    test('edit todo', () async => await editTodo(driver));
    test('delete todo', () async => await deleteTodo(driver));

    // Refuelings
    test('switch to refuelings tab',
        () async => await showRefuelingsTab(driver));
    test('new refueling', () async => await newRefueling(driver));
    test('edit refueling', () async => await editRefueling(driver));
    test('delete refueling', () async => await deleteRefueling(driver));

    // // Repeats
    // test('switch to repeats tab', () async => await showRepeatsTab(driver));
    // test('check for defaults', () async => await checkForDefaults(driver));
    // test('new repeat', () async => await newRepeat(driver));
    // test('edit repeat', () async => await editRepeat(driver));
    // test('delete repeat', () async => await deleteRepeat(driver));

    // last auth tests
    test('sign out', () async => await signOut(driver));
  });
}
