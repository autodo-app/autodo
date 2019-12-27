import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('sign in', () {
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
      await driver.waitFor(find.byValueKey('__welcome_screen__'));
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

      // expect that we will hit the home page
      await Future.delayed(Duration(milliseconds: 500));
      await driver.waitFor(find.byValueKey('__home_screen__'));
    });

    // Integration tests run sequentially
  });
}