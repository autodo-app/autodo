import 'package:autodo/blocs/database/event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadDatabase', () {
    test('props', () {
      expect(LoadDatabase().props, []);
    });
    test('toString', () {
      expect(LoadDatabase().toString(), 'LoadDatabase');
    });
  });
  group('UserLoggedIn', () {
    test('props', () {
      expect(UserLoggedIn('abcd').props, ['abcd']);
    });
    test('toString', () {
      expect(UserLoggedIn('abcd').toString(), "UserLoggedIn { uuid: abcd }");
    });
  });
}