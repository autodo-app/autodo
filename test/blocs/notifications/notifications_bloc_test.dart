import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/repositories/repositories.dart';

class MockDataRepository extends Mock with EquatableMixin implements DataRepository {}
class MockNotificationsPlugin extends Mock implements FlutterLocalNotificationsPlugin {}

void main() {
  group('NotificationsBloc', () {
    test('Null Assertion', () {
      expect(() => NotificationsBloc(dataRepository: null), throwsAssertionError);
    });
    group('LoadNotifications', () {
      blocTest<NotificationsBloc, NotificationsEvent, NotificationsState>(
        'NotificationsLoaded',
        build: () {
          final dataRepository = MockDataRepository();
          when(dataRepository.notificationID())
            .thenAnswer((_) => Stream<int>.fromIterable([0]));
          return NotificationsBloc(
            dataRepository: dataRepository,
          );
        },
        act: (bloc) async => bloc.add(LoadNotifications()),
        expect: [
          NotificationsLoading(),
          NotificationsLoaded(0)
        ]
      );
      blocTest<NotificationsBloc, NotificationsEvent, NotificationsState>(
        'Notifications is null',
        build: () {
          final dataRepository = MockDataRepository();
          when(dataRepository.notificationID())
            .thenAnswer((_) => Stream<int>.fromIterable([null]));
          return NotificationsBloc(
            dataRepository: dataRepository,
          );
        },
        act: (bloc) async => bloc.add(LoadNotifications()),
        expect: [
          NotificationsLoading(),
          NotificationsNotLoaded()
        ]
      );
      blocTest<NotificationsBloc, NotificationsEvent, NotificationsState>(
        'Exception',
        build: () {
          final dataRepository = MockDataRepository();
          return NotificationsBloc(
            dataRepository: dataRepository,
          );
        },
        act: (bloc) async => bloc.add(LoadNotifications()),
        expect: [
          NotificationsLoading(),
          NotificationsNotLoaded()
        ]
      );
    });
    blocTest<NotificationsBloc, NotificationsEvent, NotificationsState>(
      'NotificationIDUpdate',
      build: () {
        final dataRepository = MockDataRepository();
        when(dataRepository.notificationID())
          .thenAnswer((_) => Stream<int>.fromIterable([0]));
        return NotificationsBloc(
          dataRepository: dataRepository,
        );
      },
      act: (bloc) async {
        bloc.add(LoadNotifications());
        bloc.add(NotificationIdUpdated(1));
      },
      expect: [
        NotificationsLoading(),
        NotificationsLoaded(0),
        NotificationsLoaded(1),
      ]
    );
    blocTest<NotificationsBloc, NotificationsEvent, NotificationsState>(
      'ScheduleNotification',
      build: () {
        final dataRepository = MockDataRepository();
        when(dataRepository.notificationID())
          .thenAnswer((_) => Stream<int>.fromIterable([0]));
        final notificationsPlugin = MockNotificationsPlugin();
        when(notificationsPlugin.schedule(0, '', '',
            DateTime.fromMillisecondsSinceEpoch(0), 
            NotificationsBloc.platformChannelSpecifics
        )).thenAnswer((_) async {});
        return NotificationsBloc(
          notificationsPlugin: notificationsPlugin,
          dataRepository: dataRepository,
        );
      },
      act: (bloc) async {
        bloc.add(LoadNotifications());
        bloc.add(ScheduleNotification(date: DateTime.fromMillisecondsSinceEpoch(0), title: '', body: ''));
      },
      expect: [
        NotificationsLoading(),
        NotificationsLoaded(0),
        NotificationsLoaded(1),
      ]
    );
    blocTest<NotificationsBloc, NotificationsEvent, NotificationsState>(
      'ReScheduleNotification',
      build: () {
        final dataRepository = MockDataRepository();
        when(dataRepository.notificationID())
          .thenAnswer((_) => Stream<int>.fromIterable([0]));
        final notificationsPlugin = MockNotificationsPlugin();
        when(notificationsPlugin.schedule(0, '', '',
            DateTime.fromMillisecondsSinceEpoch(0), 
            NotificationsBloc.platformChannelSpecifics
        )).thenAnswer((_) async {});
        return NotificationsBloc(
          notificationsPlugin: notificationsPlugin,
          dataRepository: dataRepository,
        );
      },
      act: (bloc) async {
        bloc.add(LoadNotifications());
        bloc.add(ScheduleNotification(date: DateTime.fromMillisecondsSinceEpoch(0), title: '', body: ''));
        bloc.add(ReScheduleNotification(id: 1, date: DateTime.fromMillisecondsSinceEpoch(1), title: '', body: ''));
      },
      expect: [
        NotificationsLoading(),
        NotificationsLoaded(0),
        NotificationsLoaded(1),
        NotificationsLoaded(2),
      ]
    );
    blocTest<NotificationsBloc, NotificationsEvent, NotificationsState>(
      'ReScheduleNotification Exception',
      build: () {
        final dataRepository = MockDataRepository();
        when(dataRepository.notificationID())
          .thenAnswer((_) => Stream<int>.fromIterable([0]));
        final notificationsPlugin = MockNotificationsPlugin();
        when(notificationsPlugin.schedule(0, '', '',
            DateTime.fromMillisecondsSinceEpoch(0), 
            NotificationsBloc.platformChannelSpecifics
        )).thenAnswer((_) async {});
        when(notificationsPlugin.cancel(1)).thenThrow(Exception());
        return NotificationsBloc(
          notificationsPlugin: notificationsPlugin,
          dataRepository: dataRepository,
        );
      },
      act: (bloc) async {
        bloc.add(LoadNotifications());
        bloc.add(ScheduleNotification(date: DateTime.fromMillisecondsSinceEpoch(0), title: '', body: ''));
        bloc.add(ReScheduleNotification(id: 1, date: DateTime.fromMillisecondsSinceEpoch(1), title: '', body: ''));
      },
      expect: [
        NotificationsLoading(),
        NotificationsLoaded(0),
        NotificationsLoaded(1),
        NotificationsLoaded(2),
      ]
    );
    blocTest<NotificationsBloc, NotificationsEvent, NotificationsState>(
      'CancelNotification',
      build: () {
        final dataRepository = MockDataRepository();
        when(dataRepository.notificationID())
          .thenAnswer((_) => Stream<int>.fromIterable([0]));
        final notificationsPlugin = MockNotificationsPlugin();
        when(notificationsPlugin.schedule(0, '', '',
            DateTime.fromMillisecondsSinceEpoch(0), 
            NotificationsBloc.platformChannelSpecifics
        )).thenAnswer((_) async {});
        when(notificationsPlugin.cancel(1)).thenAnswer((_) async {});
        return NotificationsBloc(
          notificationsPlugin: notificationsPlugin,
          dataRepository: dataRepository,
        );
      },
      act: (bloc) async {
        bloc.add(LoadNotifications());
        bloc.add(ScheduleNotification(date: DateTime.fromMillisecondsSinceEpoch(0), title: '', body: ''));
        bloc.add(CancelNotification(1));
      },
      expect: [
        NotificationsLoading(),
        NotificationsLoaded(0),
        NotificationsLoaded(1),
      ]
    );
  });
}