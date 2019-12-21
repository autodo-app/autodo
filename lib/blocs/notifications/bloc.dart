import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:autodo/repositories/data_repository.dart';
import 'event.dart';
import 'state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final DataRepository _dataRepository;
  StreamSubscription _dataSubscription;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static final channelID = 'com.jonathanbayless.autodo';
  static final channelName = 'auToDo';
  static final channelDescription = 'Task reminders from the auToDo app';
  static final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelID, channelName, channelDescription,
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'auToDo notification');
  static final iOSPlatformChannelSpecifics = IOSNotificationDetails();
  static final platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  NotificationsBloc({
    notificationsPlugin,
    @required dataRepository
  }) : assert(dataRepository != null), _dataRepository = dataRepository,
       flutterLocalNotificationsPlugin = notificationsPlugin ?? FlutterLocalNotificationsPlugin();

  @override
  NotificationsState get initialState => NotificationsLoading();

  @override 
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {
    if (event is LoadNotifications) {
      yield* _mapLoadNotificationsToState(event);
    } else if (event is NotificationIdUpdated) {
      yield* _mapNotificationIdUpdateToState(event);
    } else if (event is ScheduleNotification) {
      yield* _mapScheduleNotificationToState(event);
    } else if (event is ReScheduleNotification) {
      yield* _mapReScheduleNotificationToState(event);
    } else if (event is CancelNotification) {
      yield* _mapCancelNotificationToState(event);
    }
  }

  Stream<NotificationsState> _mapLoadNotificationsToState(LoadNotifications event) async* {
    try {
      final id = await _dataRepository.notificationID().first;
      if (id != null) {
        yield NotificationsLoaded(id);
      } else {
        yield NotificationsNotLoaded();
      }
    } catch (_) {
      yield NotificationsNotLoaded();
    }
    _dataSubscription?.cancel();
    _dataSubscription = _dataRepository.notificationID().listen( 
      (id) => add(NotificationIdUpdated(id))
    );
  }

  // Future onSelectNotification(String payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: ' + payload);
  //   }
  //   // await Navigator.push(
  //   //   context,
  //   //   MaterialPageRoute(builder: (context) => SecondScreen(payload)),
  //   // );
  // }

  Stream<NotificationsState> _mapNotificationIdUpdateToState(NotificationIdUpdated event) async* {
    yield NotificationsLoaded(event.id);
  }

  Stream<NotificationsState> _mapScheduleNotificationToState(ScheduleNotification event) async* {
    if (state is NotificationsLoaded) {
      var id = (state as NotificationsLoaded).lastID + 1;
      await flutterLocalNotificationsPlugin.schedule(  
        id, event.title, event.body, event.date, platformChannelSpecifics
      );
      yield NotificationsLoaded(id);
    }
  }

  // TODO do something about these eventually
  // Future<bool> launchedByNotification() async {
  //   var notificationAppLaunchDetails =
  //       await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  //   return notificationAppLaunchDetails.didNotificationLaunchApp;
  // }

  // Future<dynamic> onDidReceiveLocalNotification(
  //     int ign1, String ign2, String ign3, String ign4) async {}

  Future<void> cancel(id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch (e) {
      // do nothing
    }
  }

  Stream<NotificationsState> _mapReScheduleNotificationToState(ReScheduleNotification event) async* {
    await cancel(event.id);
    if (state is NotificationsLoaded) {
      var id = (state as NotificationsLoaded).lastID + 1;
      await flutterLocalNotificationsPlugin.schedule(  
        id, event.title, event.body, event.date, platformChannelSpecifics
      );
      yield NotificationsLoaded(id);
    }
  }

  Stream<NotificationsState> _mapCancelNotificationToState(CancelNotification event) async* {
    await cancel(event.id);
  }

  @override 
  Future<void> close() async {
    _dataSubscription?.cancel();
    return super.close();
  }
}