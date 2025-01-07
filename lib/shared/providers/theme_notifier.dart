import 'package:flutter/material.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';

class ThemeNotifier {
  static final ThemeNotifier _instance = ThemeNotifier._internal();
  static final SharedPreferencesManager _prefs =
      SharedPreferencesManager.instance;
  final ValueNotifier<ThemeMode> themeModeNotifier;

  factory ThemeNotifier() {
    return _instance;
  }

  ThemeNotifier._internal()
      : themeModeNotifier = ValueNotifier(ThemeMode.system);

  void setThemeToDark(bool isDarkMode) {
    themeModeNotifier.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    _prefs.setBool("darkMode", isDarkMode);
  }
}

final themeNotifier = ThemeNotifier();
