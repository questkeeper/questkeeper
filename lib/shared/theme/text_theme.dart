import 'package:flutter/material.dart';
import 'package:questkeeper/shared/providers/theme_notifier.dart';
import 'package:questkeeper/shared/theme/theme_components.dart';

// Base interface for text sizes
abstract class _TextSize {
  double get displayLarge;
  double get displayMedium;
  double get displaySmall;
  double get headlineLarge;
  double get headlineMedium;
  double get headlineSmall;
  double get titleLarge;
  double get titleMedium;
  double get titleSmall;
  double get bodyLarge;
  double get bodyMedium;
  double get bodySmall;
  double get labelLarge;
  double get labelMedium;
  double get labelSmall;
}

class ModernTextTheme {
  static TextTheme create(
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
    // Get both system and user-defined text scale factors
    final systemTextScale = MediaQuery.textScaleFactorOf(context);
    final userTextScale = themeNotifier.textScaleNotifier.value;
    final combinedScale = systemTextScale * userTextScale;

    // Base sizes that will be adjusted for desktop/mobile and system scaling
    final _TextSize baseSize =
        ResponsiveTheme.isDesktop ? _DesktopTextSize() : _MobileTextSize();

    final bool isDark = brightness == Brightness.dark;
    final Color primaryTextColor = isDark ? Colors.white : Colors.black87;
    final Color secondaryTextColor = isDark ? Colors.white70 : Colors.black54;

    // Helper to create a TextStyle with the correct scaling and font
    TextStyle createStyle(
      double fontSize,
      FontWeight weight,
      double height,
      double letterSpacing,
      bool isDisplay,
      Color? color,
    ) {
      final fontStyle = (isDisplay ? displayFont : bodyFont)(
        fontSize: fontSize * combinedScale,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing * combinedScale,
        color: color,
      );

      return fontStyle;
    }

    return TextTheme(
      // Display styles
      displayLarge: createStyle(
        baseSize.displayLarge,
        FontWeight.w400,
        1.12,
        -0.25,
        true,
        primaryTextColor,
      ),
      displayMedium: createStyle(
        baseSize.displayMedium,
        FontWeight.w400,
        1.16,
        0,
        true,
        primaryTextColor,
      ),
      displaySmall: createStyle(
        baseSize.displaySmall,
        FontWeight.w400,
        1.22,
        0,
        true,
        primaryTextColor,
      ),

      // Headline styles
      headlineLarge: createStyle(
        baseSize.headlineLarge,
        FontWeight.w400,
        1.25,
        0,
        true,
        primaryTextColor,
      ),
      headlineMedium: createStyle(
        baseSize.headlineMedium,
        FontWeight.w400,
        1.29,
        0,
        true,
        primaryTextColor,
      ),
      headlineSmall: createStyle(
        baseSize.headlineSmall,
        FontWeight.w400,
        1.33,
        0,
        true,
        primaryTextColor,
      ),

      // Title styles
      titleLarge: createStyle(
        baseSize.titleLarge,
        FontWeight.w400,
        1.27,
        0,
        true,
        primaryTextColor,
      ),
      titleMedium: createStyle(
        baseSize.titleMedium,
        FontWeight.w500,
        1.5,
        0.15,
        false,
        primaryTextColor,
      ),
      titleSmall: createStyle(
        baseSize.titleSmall,
        FontWeight.w500,
        1.43,
        0.1,
        false,
        secondaryTextColor,
      ),

      // Body styles
      bodyLarge: createStyle(
        baseSize.bodyLarge,
        FontWeight.w400,
        1.5,
        0.5,
        false,
        primaryTextColor,
      ),
      bodyMedium: createStyle(
        baseSize.bodyMedium,
        FontWeight.w400,
        1.43,
        0.25,
        false,
        primaryTextColor,
      ),
      bodySmall: createStyle(
        baseSize.bodySmall,
        FontWeight.w400,
        1.33,
        0.4,
        false,
        secondaryTextColor,
      ),

      // Label styles
      labelLarge: createStyle(
        baseSize.labelLarge,
        FontWeight.w500,
        1.43,
        0.1,
        false,
        primaryTextColor,
      ),
      labelMedium: createStyle(
        baseSize.labelMedium,
        FontWeight.w500,
        1.33,
        0.5,
        false,
        secondaryTextColor,
      ),
      labelSmall: createStyle(
        baseSize.labelSmall,
        FontWeight.w500,
        1.45,
        0.5,
        false,
        secondaryTextColor,
      ),
    );
  }
}

// Desktop-optimized text sizes
class _DesktopTextSize implements _TextSize {
  @override
  final double displayLarge = 45.0;
  @override
  final double displayMedium = 36.0;
  @override
  final double displaySmall = 28.0;
  @override
  final double headlineLarge = 26.0;
  @override
  final double headlineMedium = 24.0;
  @override
  final double headlineSmall = 20.0;
  @override
  final double titleLarge = 18.0;
  @override
  final double titleMedium = 14.0;
  @override
  final double titleSmall = 13.0;
  @override
  final double bodyLarge = 14.0;
  @override
  final double bodyMedium = 13.0;
  @override
  final double bodySmall = 12.0;
  @override
  final double labelLarge = 13.0;
  @override
  final double labelMedium = 12.0;
  @override
  final double labelSmall = 11.0;
}

// Mobile-optimized text sizes (following Material 3 spec more closely)
class _MobileTextSize implements _TextSize {
  @override
  final double displayLarge = 57.0;
  @override
  final double displayMedium = 45.0;
  @override
  final double displaySmall = 36.0;
  @override
  final double headlineLarge = 32.0;
  @override
  final double headlineMedium = 28.0;
  @override
  final double headlineSmall = 24.0;
  @override
  final double titleLarge = 22.0;
  @override
  final double titleMedium = 16.0;
  @override
  final double titleSmall = 14.0;
  @override
  final double bodyLarge = 16.0;
  @override
  final double bodyMedium = 14.0;
  @override
  final double bodySmall = 12.0;
  @override
  final double labelLarge = 14.0;
  @override
  final double labelMedium = 12.0;
  @override
  final double labelSmall = 11.0;
}
