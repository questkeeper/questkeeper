import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:questkeeper/shared/theme/text_theme.dart';

class ResponsiveTheme {
  static bool get isDesktop =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  // Button dimensions
  static double get buttonHeight => isDesktop ? 28.0 : 32.0;
  static double get buttonPadding => isDesktop ? 12.0 : 16.0;
  static double get buttonVerticalPadding => isDesktop ? 8.0 : 12.0;

  // Border radius
  static double get smallRadius => isDesktop ? 6.0 : 8.0;
  static double get mediumRadius => isDesktop ? 8.0 : 12.0;
  static double get largeRadius => isDesktop ? 12.0 : 16.0;

  // Input field
  static double get inputHorizontalPadding => isDesktop ? 12.0 : 16.0;
  static double get inputVerticalPadding => isDesktop ? 8.0 : 12.0;

  // Text sizes
  static double get bodyTextSize => isDesktop ? 13.0 : 14.0;
  static double get labelTextSize => isDesktop ? 12.0 : 14.0;
  static double get helperTextSize => isDesktop ? 11.0 : 12.0;
}

class ModernTheme {
  static double get buttonHeight => ResponsiveTheme.buttonHeight;
  static double get mediumRadius => ResponsiveTheme.mediumRadius;
  static double get largeRadius => ResponsiveTheme.largeRadius;
  static double get smallRadius => ResponsiveTheme.smallRadius;

  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colors) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: ResponsiveTheme.buttonPadding,
            vertical: ResponsiveTheme.buttonVerticalPadding,
          ),
        ),
        minimumSize: WidgetStateProperty.all(Size(64, buttonHeight)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.standard,
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.onSurface.withValues(alpha: 0.38);
          }
          return colors.primary;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
              color: colors.onSurface.withValues(alpha: 0.12),
            );
          }
          if (states.contains(WidgetState.pressed)) {
            return BorderSide(
              color: colors.primary,
              width: 2,
            );
          }
          if (states.contains(WidgetState.hovered)) {
            return BorderSide(
              color: colors.primary.withValues(alpha: 0.8),
              width: 1.5,
            );
          }
          return BorderSide(
            color: colors.outline,
          );
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          return colors.primary.withValues(alpha: 0.08);
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mediumRadius),
          ),
        ),
        textStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: ResponsiveTheme.bodyTextSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }

  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colors) {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: ResponsiveTheme.buttonPadding,
            vertical: ResponsiveTheme.buttonVerticalPadding,
          ),
        ),
        minimumSize: WidgetStateProperty.all(Size(64, buttonHeight)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.standard,
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.onSurface.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.pressed)) {
            return colors.surfaceContainerHighest;
          }
          return colors.surfaceContainerHigh;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.onSurface.withValues(alpha: 0.38);
          }
          return colors.primary;
        }),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return 0;
          }
          if (states.contains(WidgetState.pressed)) {
            return 2;
          }
          if (states.contains(WidgetState.hovered)) {
            return 4;
          }
          return 1;
        }),
        shadowColor: WidgetStateProperty.all(colors.shadow),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          return colors.primary.withValues(alpha: 0.08);
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mediumRadius),
          ),
        ),
        textStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: ResponsiveTheme.bodyTextSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }

  static FilledButtonThemeData filledButtonTheme(ColorScheme colors) {
    return FilledButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: ResponsiveTheme.buttonPadding,
            vertical: ResponsiveTheme.buttonVerticalPadding,
          ),
        ),
        minimumSize: WidgetStateProperty.all(Size(64, buttonHeight)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.standard,
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.onSurface.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.pressed)) {
            return colors.primary.withValues(alpha: 0.9);
          }
          return colors.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.onSurface.withValues(alpha: 0.38);
          }
          return colors.onPrimary;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          return colors.onPrimary.withValues(alpha: 0.08);
        }),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mediumRadius),
          ),
        ),
        textStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: ResponsiveTheme.bodyTextSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }

  static TextButtonThemeData textButtonTheme(ColorScheme colors) {
    return TextButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: ResponsiveTheme.buttonPadding,
            vertical: ResponsiveTheme.buttonVerticalPadding,
          ),
        ),
        minimumSize: WidgetStateProperty.all(Size(64, buttonHeight)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.standard,
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.onSurface.withValues(alpha: 0.38);
          }
          return colors.primary;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          return colors.primary.withValues(alpha: 0.08);
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mediumRadius),
          ),
        ),
        textStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: ResponsiveTheme.bodyTextSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }

  static InputDecorationTheme inputDecorationTheme(ColorScheme colors) {
    return InputDecorationTheme(
      fillColor: colors.surfaceContainer,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      activeIndicatorBorder: BorderSide(
        color: colors.primary,
        width: 2,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveTheme.inputHorizontalPadding,
        vertical: ResponsiveTheme.inputVerticalPadding,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(mediumRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(mediumRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(mediumRadius),
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(mediumRadius),
        borderSide: BorderSide(color: colors.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(mediumRadius),
        borderSide: BorderSide(color: colors.error, width: 2),
      ),
      labelStyle: TextStyle(
        color: colors.onSurfaceVariant,
        fontSize: ResponsiveTheme.labelTextSize,
      ),
      hintStyle: TextStyle(
        color: colors.onSurfaceVariant.withValues(alpha: 0.7),
        fontSize: ResponsiveTheme.labelTextSize,
      ),
      helperStyle: TextStyle(
        color: colors.onSurfaceVariant,
        fontSize: ResponsiveTheme.helperTextSize,
      ),
      errorStyle: TextStyle(
        color: colors.error,
        fontSize: ResponsiveTheme.helperTextSize,
      ),
    );
  }

  static CheckboxThemeData checkboxTheme(ColorScheme colors) {
    return CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallRadius),
      ),
      side: BorderSide(width: 2, color: colors.outline),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.onSurface.withValues(alpha: 0.38);
        }
        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }
        return null;
      }),
    );
  }

  static AppBarTheme appBarTheme(ColorScheme colors) {
    return AppBarTheme(
      elevation: 0,
      backgroundColor: colors.surface,
    );
  }

  static BottomSheetThemeData bottomSheetTheme(ColorScheme colors) {
    return BottomSheetThemeData(
      backgroundColor: colors.surface,
      modalBackgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(largeRadius),
        ),
      ),
      elevation: 2,
    );
  }

  static IconButtonThemeData iconButtonTheme(ColorScheme colors) {
    return IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.onSurface.withValues(alpha: 0.38);
          }
          return colors.primary;
        }),
      ),
    );
  }

  static DialogThemeData dialogTheme(ColorScheme colors) {
    return DialogThemeData(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(mediumRadius),
      ),
    );
  }

  // Custom shadow for containers
  static List<BoxShadow> containerShadow(ColorScheme colors) {
    return [
      BoxShadow(
        color: colors.shadow.withValues(alpha: 0.08),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static ThemeData modernThemeData(
      BuildContext context, ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      textTheme: ModernTextTheme.create(
        context,
        displayFont: GoogleFonts.outfit,
        bodyFont: GoogleFonts.inter,
        brightness: Brightness.light,
      ),
      textButtonTheme: textButtonTheme(colorScheme),
      outlinedButtonTheme: outlinedButtonTheme(colorScheme),
      elevatedButtonTheme: elevatedButtonTheme(colorScheme),
      filledButtonTheme: filledButtonTheme(colorScheme),
      inputDecorationTheme: inputDecorationTheme(colorScheme),
      checkboxTheme: checkboxTheme(colorScheme),
      appBarTheme: appBarTheme(colorScheme),
      bottomSheetTheme: bottomSheetTheme(colorScheme),
      dialogTheme: dialogTheme(colorScheme),
    );
  }
}

extension ModernThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get text => theme.textTheme;
}
