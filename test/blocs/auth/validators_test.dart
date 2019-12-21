import 'package:autodo/blocs/auth/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    group('email validator', () {
      test('empty email', () {
        expect(Validators.isValidEmail(''), 'Email can\'t be empty');
      });
      test('no @', () {
        expect(Validators.isValidEmail('test.com'), 'Invalid email address');
      });
      test('no .', () {
        expect(Validators.isValidEmail('test@com'), 'Invalid email address');
      });
      test('valid email', () {
        expect(Validators.isValidEmail('test@test.com'), null);
      });
    });
    group('password validator', () {
      test('empty password', () {
        expect(Validators.isValidPassword(''), 'Password can\'t be empty');
      });
      test('short password', () {
        expect(Validators.isValidPassword('12345'), 'Password must be longer than 6 characters');
      });
      test('valid password', () {
        expect(Validators.isValidPassword('123456'), null);
      });
    });
  });
}