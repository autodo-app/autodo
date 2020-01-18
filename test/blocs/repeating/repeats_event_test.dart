import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

void main() {
  group('RepeatsEvent', () {
    test('LoadRepeats props', () {
      expect(LoadRepeats().props, []);
    });
    group('AddRepeat', () {
      test('props', () {
        expect(AddRepeat(Repeat()).props, [Repeat()]);
      });
      test('toString', () {
        expect(AddRepeat(Repeat()).toString(),
            'AddRepeat { repeat: ${Repeat()} }');
      });
    });
    group('UpdateRepeat', () {
      test('props', () {
        expect(UpdateRepeat(Repeat()).props, [Repeat()]);
      });
      test('toString', () {
        expect(UpdateRepeat(Repeat()).toString(),
            'UpdateRepeat { updatedRepeat: ${Repeat()} }');
      });
    });
    group('DeleteRepeat', () {
      test('props', () {
        expect(DeleteRepeat(Repeat()).props, [Repeat()]);
      });
      test('toString', () {
        expect(DeleteRepeat(Repeat()).toString(),
            'DeleteRepeat { repeat: ${Repeat()} }');
      });
    });
  });
}
