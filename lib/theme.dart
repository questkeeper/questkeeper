import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff715188),
      surfaceTint: Color(0xff715188),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xfff3daff),
      onPrimaryContainer: Color(0xff2a0c40),
      secondary: Color(0xff675a6e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffeedcf5),
      onSecondaryContainer: Color(0xff221729),
      tertiary: Color(0xff815155),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffdadb),
      onTertiaryContainer: Color(0xff331014),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xfffff7fd),
      onBackground: Color(0xff1e1a20),
      surface: Color(0xfffff7fd),
      onSurface: Color(0xff1e1a20),
      surfaceVariant: Color(0xffeadfea),
      onSurfaceVariant: Color(0xff4b454d),
      outline: Color(0xff7c757e),
      outlineVariant: Color(0xffcdc3ce),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff332f35),
      inverseOnSurface: Color(0xfff7eef6),
      inversePrimary: Color(0xffdeb8f7),
      primaryFixed: Color(0xfff3daff),
      onPrimaryFixed: Color(0xff2a0c40),
      primaryFixedDim: Color(0xffdeb8f7),
      onPrimaryFixedVariant: Color(0xff583a6f),
      secondaryFixed: Color(0xffeedcf5),
      onSecondaryFixed: Color(0xff221729),
      secondaryFixedDim: Color(0xffd2c1d9),
      onSecondaryFixedVariant: Color(0xff4f4256),
      tertiaryFixed: Color(0xffffdadb),
      onTertiaryFixed: Color(0xff331014),
      tertiaryFixedDim: Color(0xfff4b7ba),
      onTertiaryFixedVariant: Color(0xff663b3e),
      surfaceDim: Color(0xffe0d7df),
      surfaceBright: Color(0xfffff7fd),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffaf1f9),
      surfaceContainer: Color(0xfff4ebf3),
      surfaceContainerHigh: Color(0xffeee6ed),
      surfaceContainerHighest: Color(0xffe9e0e8),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff54366a),
      surfaceTint: Color(0xff715188),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff8967a0),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4a3e52),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff7e7085),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff61373a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9a676a),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff7fd),
      onBackground: Color(0xff1e1a20),
      surface: Color(0xfffff7fd),
      onSurface: Color(0xff1e1a20),
      surfaceVariant: Color(0xffeadfea),
      onSurfaceVariant: Color(0xff474149),
      outline: Color(0xff645d66),
      outlineVariant: Color(0xff807882),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff332f35),
      inverseOnSurface: Color(0xfff7eef6),
      inversePrimary: Color(0xffdeb8f7),
      primaryFixed: Color(0xff8967a0),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff6f4f86),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff7e7085),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff64576c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff9a676a),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff7e4f52),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe0d7df),
      surfaceBright: Color(0xfffff7fd),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffaf1f9),
      surfaceContainer: Color(0xfff4ebf3),
      surfaceContainerHigh: Color(0xffeee6ed),
      surfaceContainerHighest: Color(0xffe9e0e8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff311447),
      surfaceTint: Color(0xff715188),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff54366a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff291e30),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4a3e52),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3b171b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff61373a),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff7fd),
      onBackground: Color(0xff1e1a20),
      surface: Color(0xfffff7fd),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xffeadfea),
      onSurfaceVariant: Color(0xff27222a),
      outline: Color(0xff474149),
      outlineVariant: Color(0xff474149),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff332f35),
      inverseOnSurface: Color(0xffffffff),
      inversePrimary: Color(0xfff8e6ff),
      primaryFixed: Color(0xff54366a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff3d1f53),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4a3e52),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff34283b),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff61373a),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff472125),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe0d7df),
      surfaceBright: Color(0xfffff7fd),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffaf1f9),
      surfaceContainer: Color(0xfff4ebf3),
      surfaceContainerHigh: Color(0xffeee6ed),
      surfaceContainerHighest: Color(0xffe9e0e8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffdeb8f7),
      surfaceTint: Color(0xffdeb8f7),
      onPrimary: Color(0xff412357),
      primaryContainer: Color(0xff583a6f),
      onPrimaryContainer: Color(0xfff3daff),
      secondary: Color(0xffd2c1d9),
      onSecondary: Color(0xff372c3f),
      secondaryContainer: Color(0xff4f4256),
      onSecondaryContainer: Color(0xffeedcf5),
      tertiary: Color(0xfff4b7ba),
      onTertiary: Color(0xff4c2528),
      tertiaryContainer: Color(0xff663b3e),
      onTertiaryContainer: Color(0xffffdadb),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xff161217),
      onBackground: Color(0xffe9e0e8),
      surface: Color(0xff161217),
      onSurface: Color(0xffe9e0e8),
      surfaceVariant: Color(0xff4b454d),
      onSurfaceVariant: Color(0xffcdc3ce),
      outline: Color(0xff968e98),
      outlineVariant: Color(0xff4b454d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe9e0e8),
      inverseOnSurface: Color(0xff332f35),
      inversePrimary: Color(0xff715188),
      primaryFixed: Color(0xfff3daff),
      onPrimaryFixed: Color(0xff2a0c40),
      primaryFixedDim: Color(0xffdeb8f7),
      onPrimaryFixedVariant: Color(0xff583a6f),
      secondaryFixed: Color(0xffeedcf5),
      onSecondaryFixed: Color(0xff221729),
      secondaryFixedDim: Color(0xffd2c1d9),
      onSecondaryFixedVariant: Color(0xff4f4256),
      tertiaryFixed: Color(0xffffdadb),
      onTertiaryFixed: Color(0xff331014),
      tertiaryFixedDim: Color(0xfff4b7ba),
      onTertiaryFixedVariant: Color(0xff663b3e),
      surfaceDim: Color(0xff161217),
      surfaceBright: Color(0xff3c383e),
      surfaceContainerLowest: Color(0xff100d12),
      surfaceContainerLow: Color(0xff1e1a20),
      surfaceContainer: Color(0xff221e24),
      surfaceContainerHigh: Color(0xff2d292e),
      surfaceContainerHighest: Color(0xff383339),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe3bcfb),
      surfaceTint: Color(0xffdeb8f7),
      onPrimary: Color(0xff25053b),
      primaryContainer: Color(0xffa683be),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffd6c5dd),
      onSecondary: Color(0xff1c1223),
      secondaryContainer: Color(0xff9b8ba2),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff8bbbe),
      onTertiary: Color(0xff2c0b0f),
      tertiaryContainer: Color(0xffb98386),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff161217),
      onBackground: Color(0xffe9e0e8),
      surface: Color(0xff161217),
      onSurface: Color(0xfffff9fb),
      surfaceVariant: Color(0xff4b454d),
      onSurfaceVariant: Color(0xffd1c8d2),
      outline: Color(0xffa9a0aa),
      outlineVariant: Color(0xff88808a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe9e0e8),
      inverseOnSurface: Color(0xff2d292e),
      inversePrimary: Color(0xff5a3b70),
      primaryFixed: Color(0xfff3daff),
      onPrimaryFixed: Color(0xff1f0135),
      primaryFixedDim: Color(0xffdeb8f7),
      onPrimaryFixedVariant: Color(0xff47295d),
      secondaryFixed: Color(0xffeedcf5),
      onSecondaryFixed: Color(0xff170d1e),
      secondaryFixedDim: Color(0xffd2c1d9),
      onSecondaryFixedVariant: Color(0xff3d3245),
      tertiaryFixed: Color(0xffffdadb),
      onTertiaryFixed: Color(0xff25060a),
      tertiaryFixedDim: Color(0xfff4b7ba),
      onTertiaryFixedVariant: Color(0xff532a2e),
      surfaceDim: Color(0xff161217),
      surfaceBright: Color(0xff3c383e),
      surfaceContainerLowest: Color(0xff100d12),
      surfaceContainerLow: Color(0xff1e1a20),
      surfaceContainer: Color(0xff221e24),
      surfaceContainerHigh: Color(0xff2d292e),
      surfaceContainerHighest: Color(0xff383339),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff9fb),
      surfaceTint: Color(0xffdeb8f7),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffe3bcfb),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffff9fb),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffd6c5dd),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9f9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xfff8bbbe),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff161217),
      onBackground: Color(0xffe9e0e8),
      surface: Color(0xff161217),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff4b454d),
      onSurfaceVariant: Color(0xfffff9fb),
      outline: Color(0xffd1c8d2),
      outlineVariant: Color(0xffd1c8d2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe9e0e8),
      inverseOnSurface: Color(0xff000000),
      inversePrimary: Color(0xff3a1c50),
      primaryFixed: Color(0xfff5dfff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffe3bcfb),
      onPrimaryFixedVariant: Color(0xff25053b),
      secondaryFixed: Color(0xfff3e1fa),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffd6c5dd),
      onSecondaryFixedVariant: Color(0xff1c1223),
      tertiaryFixed: Color(0xffffdfe0),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xfff8bbbe),
      onTertiaryFixedVariant: Color(0xff2c0b0f),
      surfaceDim: Color(0xff161217),
      surfaceBright: Color(0xff3c383e),
      surfaceContainerLowest: Color(0xff100d12),
      surfaceContainerLow: Color(0xff1e1a20),
      surfaceContainer: Color(0xff221e24),
      surfaceContainerHigh: Color(0xff2d292e),
      surfaceContainerHighest: Color(0xff383339),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
