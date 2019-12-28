import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';

void main() {
  group('LoginEvent', () {
    test('LoginEmailChanged props', () {
      expect(LoginWithGooglePressed().props, []);
    });
    test('LoginEmailChanged props', () {
      expect(LoginEmailChanged(email: '').props, ['']);
    });
    test('LoginPasswordChanged props', () {
      expect(LoginPasswordChanged(password: '').props, ['']);
    });
    test('LoginSubmitted props', () {
      expect(
          LoginWithCredentialsPressed(email: '', password: '').props, ['', '']);
    });
    test('SendPasswordResetPressed props', () {
      expect(SendPasswordResetPressed(email: '').props, ['']);
    });
  });
}
