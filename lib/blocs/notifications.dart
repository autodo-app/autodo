import 'dart:async';
import 'package:autodo/blocs/firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationBLoC {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static final channelID = 'com.jonathanbayless.autodo';
  static final channelName =  'auToDo';
  static final channelDescription = 'Task reminders from the auToDo app';
  static final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelID, channelName, channelDescription,
        importance: Importance.Max, priority: Priority.High, ticker: 'auToDo notification');
  static final iOSPlatformChannelSpecifics = IOSNotificationDetails();
  static final platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => SecondScreen(payload)),
    // );
  }

  Future<void> pushBasicNotification({title, body}) async {
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: 'TODO: item name');
  }

  Future<int> getNextNotificationID() async {
    var userDoc = await FirestoreBLoC.fetchUserDocument();
    var userData = await userDoc.get();
    if (!userData.data.containsKey('lastNotificationID')) {
      var lastID = 0;
      var userJSON = userData.data;
      userJSON['lastNotificationID'] = lastID;
      userDoc.updateData(userJSON);
      return lastID;
    }
    int lastID = userData.data['lastNotificationID'];
    lastID++;
    var userJSON = userData.data;
    userJSON['lastNotificationID'] = lastID;
    userDoc.updateData(userJSON);
    return lastID;
  }

  Future<int> scheduleNotification({@required DateTime datetime, @required String title, @required String body}) async {
    // Set a value in the user's db with the id value corresponding to this notification?
    var id = await getNextNotificationID();
    await flutterLocalNotificationsPlugin.schedule(
        id,
        title,
        body,
        datetime,
        platformChannelSpecifics);
    return id;
  }

  Future<void> repeatedlyNotify() async {
    // Show a notification every minute with the first appearance happening a minute after invoking the method
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
        'repeating body', RepeatInterval.EveryMinute, platformChannelSpecifics);
  }

  Future<void> cancel({id}) async {
    // cancel the notification with id value of zero
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch (e) {
      print(e);
    }
  }
  
  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<bool> launchedByNotification() async {
    var notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    return notificationAppLaunchDetails.didNotificationLaunchApp;
  }

  Future<dynamic> onDidReceiveLocalNotification(int ign1, String ign2, String ign3, String ign4) async {}

  Future<void> printPendingNotifications() async {
    var requests = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    requests.forEach((f) {
      print(f.title);
    });
  }
  
  // Make the object a Singleton
  static final NotificationBLoC _bloc = NotificationBLoC._internal();
  factory NotificationBLoC() {
    return _bloc;
  }
  NotificationBLoC._internal() {
    // Initialize the plugin's settings
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
}
