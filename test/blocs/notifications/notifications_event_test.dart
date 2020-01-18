import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/blocs/blocs.dart';

void main() {
  group('NotificationsEvents', () {
    test('LoadNotifications props', () {
      expect(LoadNotifications().props, []);
    });
    group('NotificationIdUpdated', () {
      test('props', () {
        expect(NotificationIdUpdated(0).props, [0]);
      });
      test('toString', () {
        expect(NotificationIdUpdated(0).toString(),
            "NotificationIdUpdated { id: 0 }");
      });
    });
    group('ScheduleNotification', () {
      test('props', () {
        expect(
            ScheduleNotification(
                    date: DateTime.fromMillisecondsSinceEpoch(0),
                    title: 'test',
                    body: 'here')
                .props,
            [DateTime.fromMillisecondsSinceEpoch(0), 'test', 'here']);
      });
      test('toString', () {
        expect(
            ScheduleNotification(
                    date: DateTime.fromMillisecondsSinceEpoch(0),
                    title: 'test',
                    body: 'here')
                .toString(),
            "ScheduleNotification { date: ${DateTime.fromMillisecondsSinceEpoch(0)}, title: test, body: here }");
      });
    });
    group('ReScheduleNotification', () {
      test('props', () {
        expect(
            ReScheduleNotification(
                    id: 1,
                    date: DateTime.fromMillisecondsSinceEpoch(0),
                    title: 'test',
                    body: 'here')
                .props,
            [1, DateTime.fromMillisecondsSinceEpoch(0), 'test', 'here']);
      });
      test('toString', () {
        expect(
            ReScheduleNotification(
                    id: 1,
                    date: DateTime.fromMillisecondsSinceEpoch(0),
                    title: 'test',
                    body: 'here')
                .toString(),
            "ReScheduleNotification { id: 1, date: ${DateTime.fromMillisecondsSinceEpoch(0)}, title: test, body: here }");
      });
    });
    group('CancelNotification', () {
      test('props', () {
        expect(CancelNotification(0).props, [0]);
      });
      test('toString', () {
        expect(
            CancelNotification(0).toString(), 'CancelNotification { id: 0 }');
      });
    });
  });
}
