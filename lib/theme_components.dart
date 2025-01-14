import 'package:flutter/material.dart';

class ModernTheme {
  static const double buttonHeight = 32.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double smallRadius = 8.0;

  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colors) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        minimumSize: WidgetStateProperty.all(const Size(64, buttonHeight)),
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
          const TextStyle(
            fontSize: 14,
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
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        minimumSize: WidgetStateProperty.all(const Size(64, buttonHeight)),
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
          const TextStyle(
            fontSize: 14,
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
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        minimumSize: WidgetStateProperty.all(const Size(64, buttonHeight)),
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
          const TextStyle(
            fontSize: 14,
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
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        minimumSize: WidgetStateProperty.all(const Size(64, buttonHeight)),
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
          const TextStyle(
            fontSize: 14,
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
      contentPadding: const EdgeInsets.symmetric(
        horizontal: largeRadius,
        vertical: mediumRadius,
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
        fontSize: 14,
      ),
      hintStyle: TextStyle(
        color: colors.onSurfaceVariant.withValues(alpha: 0.7),
        fontSize: 14,
      ),
      helperStyle: TextStyle(
        color: colors.onSurfaceVariant,
        fontSize: 12,
      ),
      errorStyle: TextStyle(
        color: colors.error,
        fontSize: 12,
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(largeRadius),
        ),
      ),
      elevation: 2,
    );
  }

  static IconButtonThemeData iconButtonTheme(ColorScheme colors) {
    return IconButtonThemeData(style: ButtonStyle(
      iconColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.onSurface.withValues(alpha: 0.38);
        }
        return colors.primary;
      }),
    ));
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

  static ThemeData modernThemeData(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
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
