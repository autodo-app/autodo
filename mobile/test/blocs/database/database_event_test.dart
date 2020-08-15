import 'package:autodo/blocs/blocs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserLoggedIn', () {
    test('props', () {
      expect(UserLoggedIn('abcd').props, ['abcd']);
    });
    test('toString', () {
      expect(UserLoggedIn('abcd').toString(), 'UserLoggedIn { uuid: abcd }');
    });
  });
  group('UserLoggedOut', () {
    test('props', () {
      expect(UserLoggedOut().props, []);
    });
  });
  group('triallogin', () {
    test('props', () {
      expect(TrialLogin().props, []);
    });
    test('toString', () {
      expect(TrialLogin().toString(), 'TrialLogin { }');
    });
  });
}
