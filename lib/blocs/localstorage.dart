import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static read(String key, String valType) async {
    final prefs = await SharedPreferences.getInstance();
    switch (valType) {
      case "string":
        return prefs.getString(key);
    }
  }

  static save<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();
    if (T == String)
      prefs.setString(key, value as String);
    else if (T == int)
      prefs.setInt(key, value as int);
    else if (T == bool)
      prefs.setBool(key, value as bool);
    else if (T == double) prefs.setDouble(key, value as double);
  }
}
