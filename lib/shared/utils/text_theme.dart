import 'package:flutter/material.dart';

TextTheme createTextTheme(
  BuildContext context, {
  required TextStyle Function({
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
  }) displayFont,
  required TextStyle Function({
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
  }) bodyFont,
}) {
  TextStyle createStyle(
    TextStyle Function({
      double? fontSize,
      FontWeight? fontWeight,
      double? letterSpacing,
      double? height,
    }) fontFamily, {
    required double fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
  }) {
    return fontFamily(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  return TextTheme(
    // Display styles using displayFont (Raleway by default)
    displayLarge: createStyle(displayFont,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12),
    displayMedium: createStyle(displayFont,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16),
    displaySmall: createStyle(displayFont,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22),

    // Headline styles
    headlineLarge: createStyle(displayFont,
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.25),
    headlineMedium: createStyle(displayFont,
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.29),
    headlineSmall: createStyle(displayFont,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.33),

    // Title styles
    titleLarge: createStyle(displayFont,
        fontSize: 22,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.27),
    titleMedium: createStyle(displayFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.5),
    titleSmall: createStyle(displayFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.43),

    // Body styles using bodyFont (Noto Sans by default)
    bodyLarge: createStyle(bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5),
    bodyMedium: createStyle(bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43),
    bodySmall: createStyle(bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33),

    // Label styles
    labelLarge: createStyle(bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43),
    labelMedium: createStyle(bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33),
    labelSmall: createStyle(bodyFont,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45),
  );
}
