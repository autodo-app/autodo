import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:autodo/screens/loadingpage.dart';

class NotificationBLoC {
  // TODO: add functions formatting the Map for each of the kotlin code's possible options
  static final MethodChannel android =
      MethodChannel('com.jonathanbayless.autodo/android');

  Future<void> launchReturn(String payload) async {
    // Navigator.pushNamed(key.currentContext, '/load');
  }

  Future<void> _handler(MethodCall call) {
    switch (call.method) {
      case 'launch':
        return launchReturn(call.arguments);
      default:
        return Future.error('method not defined');
    }
  }

  NotificationBLoC() {
    // android.setMethodCallHandler(_handler);
  }

  static Future<void> pushBasicNotification(
      {@required title, @required content}) async {
    var args = {"title": title, "content": content};
    android.invokeMethod('pushNotification', args);
  }
}
