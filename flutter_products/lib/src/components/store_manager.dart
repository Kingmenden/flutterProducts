import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  /*static void saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      print("Invalid Type");
    }
  }

  static Future<dynamic> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get(key) != '') {
      dynamic obj = prefs.get(key);
      return obj;
    } else {
      return null;
    }
  }

  static Future<bool> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }*/
  SharedPreferences? _prefs;

  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool?> isDarkMode() async {
    await _init();
    return _prefs?.getBool('isDarkMode');
  }

  Future<void> setTheme(bool isDarkMode) async {
    await _init();
    await _prefs?.setBool('isDarkMode', isDarkMode);
  }
}
