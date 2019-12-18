import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/barrel.dart';

void main() {
  group('Auth Bloc', () {
    test('props for state are empty', () {
      expect(Uninitialized().props, []);
    });
    test('Authenticated toString', () {
      String displayName = "test";
      String uuid = "abcd";
      expect(
        Authenticated(displayName, uuid).toString(),
        'Authenticated { displayName: $displayName, uuid: $uuid }'
      );
    });
    test('Authenticated props', () {
      String displayName = "test";
      String uuid = "abcd";
      expect(
        Authenticated(displayName, uuid).props,
        [displayName, uuid]
      );
    });
    test('Unauthenticated toString', () {
      String errorCode = "abcd";
      expect(
        Unauthenticated(errorCode: errorCode).toString(),
        'Unauthenticated { errorCode: $errorCode }'
      );
    });
    test('Unauthenticated props', () {
      String errorCode = "abcd";
      expect(
        Unauthenticated(errorCode: errorCode).props,
        [errorCode]
      );
    });
  });
}