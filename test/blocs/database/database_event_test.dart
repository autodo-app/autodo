import 'package:autodo/blocs/blocs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserLoggedIn', () {
    test('props', () {
      expect(UserLoggedIn('abcd').props, ['abcd', null]);
    });
    test('toString', () {
      expect(UserLoggedIn('abcd').toString(),
          "UserLoggedIn { uuid: abcd, newUser: null }");
    });
  });
  group('UserLoggedOut', () {
    test('props', () {
      expect(UserLoggedOut().props, []);
    });
  });
}
