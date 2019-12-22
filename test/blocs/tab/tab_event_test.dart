import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

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