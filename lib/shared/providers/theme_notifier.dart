import 'package:flutter/material.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';

class ThemeNotifier {
  static final ThemeNotifier _instance = ThemeNotifier._internal();
  factory ThemeNotifier() => _instance;
  ThemeNotifier._internal();

  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier(ThemeMode.system);
  final ValueNotifier<double> textScaleNotifier = ValueNotifier(1.0);
  static const String _themeKey = "theme_mode";
  static const String _textScaleKey = "text_scale_factor";

  Future<void> init() async {
    final prefs = SharedPreferencesManager.instance;
    final savedTheme = prefs.getString(_themeKey);
    if (savedTheme != null) {
      themeModeNotifier.value = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }

    final savedScale = prefs.getDouble(_textScaleKey);
    if (savedScale != null) {
      textScaleNotifier.value = savedScale;
    }
  }

  Future<void> setThemeToDark(bool isDark) async {
    final newMode = isDark ? ThemeMode.dark : ThemeMode.light;
    themeModeNotifier.value = newMode;
    await SharedPreferencesManager.instance
        .setString(_themeKey, newMode.toString());
  }

  Future<void> setTextScale(double scale) async {
    textScaleNotifier.value = scale;
    await SharedPreferencesManager.instance.setDouble(_textScaleKey, scale);
  }
}

final themeNotifier = ThemeNotifier();
