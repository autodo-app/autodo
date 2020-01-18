import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';

void main() {
  group('SignupEvent', () {
    test('SignupEmailChanged props', () {
      expect(SignupEmailChanged(email: '').props, ['']);
    });
    test('SignupPasswordChanged props', () {
      expect(SignupPasswordChanged(password: '').props, ['']);
    });
    test('SignupWithCredentialsPressed props', () {
      expect(SignupWithCredentialsPressed(email: '', password: '').props,
          ['', '']);
    });
  });
}
