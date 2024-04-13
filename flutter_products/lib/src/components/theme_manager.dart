import 'package:flutter/material.dart';
import 'package:flutter_products/constants.dart';

import 'store_manager.dart';
//import 'store_manager.dart';

class ThemeNotifier with ChangeNotifier {
  static final _instance = ThemeNotifier._();
  ThemeNotifier._() {
    _getThemeMode();
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  //bool isDarkMode = false;

  /*final darkTheme = ThemeData(
    scaffoldBackgroundColor: kbackgroundColor,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    hintColor: Colors.white,
    //actionIconTheme: ActionIconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(
      background: const Color(0xFF212121),
      brightness: Brightness.dark,
    ),
  );

  final lightTheme = ThemeData(
    scaffoldBackgroundColor: kbackgroundColor,
    primaryColor: kPrimaryColor,
    brightness: Brightness.light,
    hintColor: Colors.black,
    //actionIconTheme: const ActionIconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(
      background: kbackgroundColor,
      brightness: Brightness.light,
    ),
  );
  var _themeData = ThemeData(
    scaffoldBackgroundColor: kbackgroundColor,
    primaryColor: kPrimaryColor,
  );*/
  //ThemeData getTheme() => _themeData;
  /*ThemeNotifier() {
    if (StorageManager.readData('themeMode') != null) {
      StorageManager.readData('themeMode').then((value) {
        print('value read from storage: ' + value.toString());
        var themeMode = value ?? 'light';
        if (themeMode == 'light') {
          _themeData = lightTheme;
        } else {
          isDarkMode = true;
          print('setting dark theme');
          _themeData = darkTheme;
        }
        notifyListeners();
      });
    } else {
      _themeData = lightTheme;
      print(_themeData);
    }
  }*/

  /*void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    isDarkMode = true;
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    isDarkMode = false;
    notifyListeners();
  }*/

  factory ThemeNotifier() {
    return _instance;
  }

  ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: kbackgroundColor,
        brightness: Brightness.light,
        hintColor: Colors.black,
        dividerColor: Colors.white54,
        iconTheme: const IconThemeData(color: Colors.black),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
          titleLarge: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(
          background: kbackgroundColor,
          brightness: Brightness.light,
        ),
      );

  ThemeData get darkTheme => ThemeData(
        scaffoldBackgroundColor: Colors.grey[900],
        brightness: Brightness.dark,
        hintColor: Colors.white,
        dividerColor: Colors.black12,
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.grey[200]),
          titleLarge: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(
          background: kbackgroundColor,
          brightness: Brightness.dark,
        ),
      );

  final _localDb = StorageManager();
  Future<void> toggleTheme(BuildContext context) async {
    switch (_themeMode) {
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.light;
        break;
      case ThemeMode.system:
        if (Theme.of(context).scaffoldBackgroundColor == Colors.white) {
          _themeMode = ThemeMode.dark;
        } else {
          _themeMode = ThemeMode.light;
        }
    }
    await _localDb.setTheme(_themeMode == ThemeMode.dark);
    notifyListeners();
  }

  Future<void> _getThemeMode() async {
    final isDarkMode = await _localDb.isDarkMode();

    if (isDarkMode == true) {
      _themeMode = ThemeMode.dark;
      notifyListeners();
    } else if (isDarkMode == false) {
      _themeMode = ThemeMode.light;
      notifyListeners();
    }
  }
}
