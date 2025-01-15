import 'package:flutter/material.dart';

TextTheme createTextTheme(
  BuildContext context, {
  required TextStyle Function({
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
    Color? color,
  }) displayFont,
  required TextStyle Function({
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
    Color? color,
  }) bodyFont,
  required Brightness brightness,
}) {
  final bool isDark = brightness == Brightness.dark;
  final Color primaryTextColor = isDark ? Colors.white : Colors.black87;
  final Color secondaryTextColor = isDark ? Colors.white70 : Colors.black54;

  TextStyle createStyle(
    TextStyle Function({
      double? fontSize,
      FontWeight? fontWeight,
      double? letterSpacing,
      double? height,
      Color? color,
    }) fontFamily, {
    required double fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
    Color? color,
  }) {
    return fontFamily(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  return TextTheme(
    // Display
    displayLarge: createStyle(displayFont,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
        color: primaryTextColor),
    displayMedium: createStyle(displayFont,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16,
        color: primaryTextColor),
    displaySmall: createStyle(displayFont,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
        color: primaryTextColor),

    // Title
    headlineLarge: createStyle(displayFont,
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.25,
        color: primaryTextColor),
    headlineMedium: createStyle(displayFont,
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.29,
        color: primaryTextColor),
    headlineSmall: createStyle(displayFont,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.33,
        color: primaryTextColor),

    // Title
    titleLarge: createStyle(displayFont,
        fontSize: 22,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.27,
        color: primaryTextColor),
    titleMedium: createStyle(displayFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.5,
        color: primaryTextColor),
    titleSmall: createStyle(displayFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.43,
        color: secondaryTextColor),

    // Body
    bodyLarge: createStyle(bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
        color: primaryTextColor),
    bodyMedium: createStyle(bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
        color: primaryTextColor),
    bodySmall: createStyle(bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
        color: secondaryTextColor),

    // Label
    labelLarge: createStyle(bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
        color: primaryTextColor),
    labelMedium: createStyle(bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
        color: secondaryTextColor),
    labelSmall: createStyle(bodyFont,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
        color: secondaryTextColor),
  );
}
