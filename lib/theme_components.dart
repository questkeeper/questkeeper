import 'package:flutter/material.dart';

class ComponentsTheme {
  static textButtonTheme() {
    return TextButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
        foregroundColor: MaterialStateProperty.all(const Color(0xFF3F51B5)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        iconSize: MaterialStateProperty.all(18),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  static outlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  static elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  static filledButtonTheme() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  static InputDecorationTheme inputDecorationTheme() {
    return const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
  }

  static AppBarTheme appBarTheme() {
    return const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    );
  }

  static ThemeData componentsThemeData = ThemeData(
    textButtonTheme: textButtonTheme(),
    outlinedButtonTheme: outlinedButtonTheme(),
    appBarTheme: appBarTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    elevatedButtonTheme: elevatedButtonTheme(),
  );
}
