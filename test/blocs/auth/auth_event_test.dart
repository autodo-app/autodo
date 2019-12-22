import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';

void main() {
  group('Auth Bloc', () {
    test('props for event are empty', () {
      expect(AppStarted().props, []);
    });
  });
}