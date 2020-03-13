import 'package:shared_preferences/shared_preferences.dart';

/// 数据存取
class LocalStorage {

  static SharedPreferences preferences;

  static Future<bool> getInstance() async {
    preferences = await SharedPreferences.getInstance();
    return true;
  }

  static save(String key, value) {
    SharedPreferences prefs = preferences;
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      prefs.setStringList(key, value);
    }
  }

  static get(String key) {
    SharedPreferences prefs = preferences;
    return prefs.get(key);
  }

  static remove(String key) {
    SharedPreferences prefs = preferences;
    prefs.remove(key);
  }
}