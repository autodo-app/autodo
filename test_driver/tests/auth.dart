import 'package:flutter_driver/flutter_driver.dart';

/// Signs up a new user to kick off the test sequence
Future<void> signUp(FlutterDriver driver) async {
  // Welcome Screen
  await driver.waitFor(find.byValueKey('__welcome_screen__'),
      timeout: Duration(minutes: 2));
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
  await driver.waitFor(find.byType('MileageScreen'),
      timeout: Duration(minutes: 1));
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
}

Future<void> startTrial(FlutterDriver driver) async {
  await driver.waitFor(find.byValueKey('__welcome_screen__'));
  await driver.tap(find.byType('TrialButton'));

  // mileage setting screen
  await Future.delayed(Duration(milliseconds: 500));
  await driver.waitFor(find.byType('MileageScreen'),
      timeout: Duration(minutes: 1));
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
}

/// Signs out the currently logged in user
Future<void> signOut(FlutterDriver driver) async {
  print('signing out');
  // this tooltip exists by default as the means for opening the nav drawer
  await driver.tap(find.byTooltip("Open navigation menu"));
  await driver.tap(find.byValueKey('__sign_out_button__'));

  // should be in the welcome screen again now
  await driver.waitFor(find.byValueKey('__welcome_screen__'));
}

/// Signs back in with the previously created user
Future<void> signIn(FlutterDriver driver) async {
  // Welcome Screen
  await driver.waitFor(find.byValueKey('__welcome_screen__'),
      timeout: Duration(minutes: 2));
  await driver.tap(find.byValueKey('__welcome_login_button__'));
  print('Welcome Screen completed');

  // Enter email and password into login screen
  await driver.waitFor(find.byValueKey('__login_screen__'));
  await driver.enterText('integration-test@autodo.app');
  await driver.tap(find.byType('PasswordForm'));
  await driver.enterText('123456');
  await driver.tap(find.byType('LoginSubmitButton'));
  print('Signup Screen Completed');

  // home screen
  await driver.waitFor(find.byValueKey('__home_screen__'),
      timeout: Duration(minutes: 2));
}

/// Deletes the test user that we created
Future<void> deleteUser(FlutterDriver driver) async {
  print('deleting account');
  // this tooltip exists by default as the means for opening the nav drawer
  await driver.tap(find.byTooltip("Open navigation menu"));
  await driver.tap(find.byValueKey('__settings_drawer_button__'));

  // settings screen
  await driver.waitFor(find.byType('SettingsScreen'));
  await driver.tap(find.byValueKey('__delete_account_button__'));
  // alert dialog for confirmation
  await driver.tap(find.byValueKey('__delete_account_confirm__'));

  // should be in the welcome screen again now
  await driver.waitFor(find.byValueKey('__welcome_screen__'));
}
