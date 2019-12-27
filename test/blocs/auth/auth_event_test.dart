import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';

void main() {
  group('Auth Bloc', () {
    test('integrationTest is null by default', () {
      expect(AppStarted().props, [null]);
    });
  });
}