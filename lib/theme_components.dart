import 'package:flutter/material.dart';

class ComponentsTheme {
  static textButtonTheme() {
    return TextButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24),
        ),
        foregroundColor: WidgetStateProperty.all(const Color(0xFF3F51B5)),
        fixedSize: WidgetStateProperty.all(
          const Size.fromHeight(40),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        iconSize: WidgetStateProperty.all(18),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  static outlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        padding:
            WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 24)),
        fixedSize: WidgetStateProperty.all(
          const Size.fromHeight(40),
        ),
        shape: WidgetStateProperty.all(
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
        padding:
            WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 24)),
        fixedSize: WidgetStateProperty.all(
          const Size.fromHeight(40),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  static filledButtonTheme() {
    return FilledButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w600),
        ),
        padding:
            WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 24)),
        fixedSize: WidgetStateProperty.all(
          const Size.fromHeight(40),
        ),
        shape: WidgetStateProperty.all(
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
    filledButtonTheme: filledButtonTheme(),
    bottomSheetTheme: bottomSheetTheme(),
  );

  static BottomSheetThemeData bottomSheetTheme() {
    return const BottomSheetThemeData(
      modalBackgroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
    );
  }
}
