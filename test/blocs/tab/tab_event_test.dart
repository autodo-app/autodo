import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/barrel.dart';
import 'package:autodo/models/barrel.dart';

void main() {
  group('TabEvent', ()  {
    test('props', () {
      expect(UpdateTab(AppTab.refuelings).props, [AppTab.refuelings]);
    });
    test('toString', () {
      expect(UpdateTab(AppTab.refuelings).toString(), 'UpdateTab { tab: ${AppTab.refuelings} }');
    });
  });
}