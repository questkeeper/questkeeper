import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff6d3694),
      surfaceTint: Color(0xff7c45a4),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff945cbc),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff8d4f00),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffb36d),
      onSecondaryContainer: Color(0xff502a00),
      tertiary: Color(0xff8c2b54),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffba5079),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xfffff7fd),
      onBackground: Color(0xff1e1a20),
      surface: Color(0xfffff7fd),
      onSurface: Color(0xff1e1a20),
      surfaceVariant: Color(0xffebdeee),
      onSurfaceVariant: Color(0xff4c4450),
      outline: Color(0xff7e7481),
      outlineVariant: Color(0xffcfc3d2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff342f35),
      inverseOnSurface: Color(0xfff7eef7),
      inversePrimary: Color(0xffe2b6ff),
      primaryFixed: Color(0xfff3daff),
      onPrimaryFixed: Color(0xff2e004d),
      primaryFixedDim: Color(0xffe2b6ff),
      onPrimaryFixedVariant: Color(0xff632c8a),
      secondaryFixed: Color(0xffffdcc0),
      onSecondaryFixed: Color(0xff2d1600),
      secondaryFixedDim: Color(0xffffb877),
      onSecondaryFixedVariant: Color(0xff6b3b00),
      tertiaryFixed: Color(0xffffd9e3),
      onTertiaryFixed: Color(0xff3e001e),
      tertiaryFixedDim: Color(0xffffb0c9),
      onTertiaryFixedVariant: Color(0xff80214b),
      surfaceDim: Color(0xffe0d7e0),
      surfaceBright: Color(0xfffff7fd),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffaf1fa),
      surfaceContainer: Color(0xfff5ebf4),
      surfaceContainerHigh: Color(0xffefe5ee),
      surfaceContainerHighest: Color(0xffe9e0e9),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff5e2786),
      surfaceTint: Color(0xff7c45a4),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff945cbc),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff663700),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffab630d),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff7b1d47),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffba5079),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff7fd),
      onBackground: Color(0xff1e1a20),
      surface: Color(0xfffff7fd),
      onSurface: Color(0xff1e1a20),
      surfaceVariant: Color(0xffebdeee),
      onSurfaceVariant: Color(0xff48404c),
      outline: Color(0xff655c69),
      outlineVariant: Color(0xff817785),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff342f35),
      inverseOnSurface: Color(0xfff7eef7),
      inversePrimary: Color(0xffe2b6ff),
      primaryFixed: Color(0xff945cbc),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff7943a1),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xffab630d),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff8a4d00),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xffba5079),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff9c3861),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe0d7e0),
      surfaceBright: Color(0xfffff7fd),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffaf1fa),
      surfaceContainer: Color(0xfff5ebf4),
      surfaceContainerHigh: Color(0xffefe5ee),
      surfaceContainerHighest: Color(0xffe9e0e9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff38005b),
      surfaceTint: Color(0xff7c45a4),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5e2786),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff371b00),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff663700),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4a0025),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff7b1d47),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff7fd),
      onBackground: Color(0xff1e1a20),
      surface: Color(0xfffff7fd),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xffebdeee),
      onSurfaceVariant: Color(0xff28212c),
      outline: Color(0xff48404c),
      outlineVariant: Color(0xff48404c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff342f35),
      inverseOnSurface: Color(0xffffffff),
      inversePrimary: Color(0xfff8e6ff),
      primaryFixed: Color(0xff5e2786),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff46076e),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff663700),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff462400),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff7b1d47),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5d0131),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe0d7e0),
      surfaceBright: Color(0xfffff7fd),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffaf1fa),
      surfaceContainer: Color(0xfff5ebf4),
      surfaceContainerHigh: Color(0xffefe5ee),
      surfaceContainerHighest: Color(0xffe9e0e9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe2b6ff),
      surfaceTint: Color(0xffe2b6ff),
      onPrimary: Color(0xff4a0e72),
      primaryContainer: Color(0xff945cbc),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xffffd8b8),
      onSecondary: Color(0xff4b2700),
      secondaryContainer: Color(0xfff9a24c),
      onSecondaryContainer: Color(0xff422200),
      tertiary: Color(0xffffb0c9),
      onTertiary: Color(0xff620534),
      tertiaryContainer: Color(0xffba5079),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xff161218),
      onBackground: Color(0xffe9e0e9),
      surface: Color(0xff161218),
      onSurface: Color(0xffe9e0e9),
      surfaceVariant: Color(0xff4c4450),
      onSurfaceVariant: Color(0xffcfc3d2),
      outline: Color(0xff988d9b),
      outlineVariant: Color(0xff4c4450),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe9e0e9),
      inverseOnSurface: Color(0xff342f35),
      inversePrimary: Color(0xff7c45a4),
      primaryFixed: Color(0xfff3daff),
      onPrimaryFixed: Color(0xff2e004d),
      primaryFixedDim: Color(0xffe2b6ff),
      onPrimaryFixedVariant: Color(0xff632c8a),
      secondaryFixed: Color(0xffffdcc0),
      onSecondaryFixed: Color(0xff2d1600),
      secondaryFixedDim: Color(0xffffb877),
      onSecondaryFixedVariant: Color(0xff6b3b00),
      tertiaryFixed: Color(0xffffd9e3),
      onTertiaryFixed: Color(0xff3e001e),
      tertiaryFixedDim: Color(0xffffb0c9),
      onTertiaryFixedVariant: Color(0xff80214b),
      surfaceDim: Color(0xff161218),
      surfaceBright: Color(0xff3d373e),
      surfaceContainerLowest: Color(0xff110d13),
      surfaceContainerLow: Color(0xff1e1a20),
      surfaceContainer: Color(0xff221e24),
      surfaceContainerHigh: Color(0xff2d282f),
      surfaceContainerHighest: Color(0xff38333a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe5bbff),
      surfaceTint: Color(0xffe2b6ff),
      onPrimary: Color(0xff270041),
      primaryContainer: Color(0xffb278db),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffd8b8),
      onSecondary: Color(0xff3f2000),
      secondaryContainer: Color(0xfff9a24c),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffb7cd),
      onTertiary: Color(0xff350019),
      tertiaryContainer: Color(0xffdd6b96),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff161218),
      onBackground: Color(0xffe9e0e9),
      surface: Color(0xff161218),
      onSurface: Color(0xfffff9fb),
      surfaceVariant: Color(0xff4c4450),
      onSurfaceVariant: Color(0xffd3c7d6),
      outline: Color(0xffaa9fae),
      outlineVariant: Color(0xff8a808d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe9e0e9),
      inverseOnSurface: Color(0xff2d282f),
      inversePrimary: Color(0xff642d8b),
      primaryFixed: Color(0xfff3daff),
      onPrimaryFixed: Color(0xff1f0036),
      primaryFixedDim: Color(0xffe2b6ff),
      onPrimaryFixedVariant: Color(0xff501778),
      secondaryFixed: Color(0xffffdcc0),
      onSecondaryFixed: Color(0xff1f0d00),
      secondaryFixedDim: Color(0xffffb877),
      onSecondaryFixedVariant: Color(0xff542c00),
      tertiaryFixed: Color(0xffffd9e3),
      onTertiaryFixed: Color(0xff2b0013),
      tertiaryFixedDim: Color(0xffffb0c9),
      onTertiaryFixedVariant: Color(0xff6a0e3a),
      surfaceDim: Color(0xff161218),
      surfaceBright: Color(0xff3d373e),
      surfaceContainerLowest: Color(0xff110d13),
      surfaceContainerLow: Color(0xff1e1a20),
      surfaceContainer: Color(0xff221e24),
      surfaceContainerHigh: Color(0xff2d282f),
      surfaceContainerHighest: Color(0xff38333a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff9fb),
      surfaceTint: Color(0xffe2b6ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffe5bbff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffffaf8),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffffbd83),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9f9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffb7cd),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff161218),
      onBackground: Color(0xffe9e0e9),
      surface: Color(0xff161218),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff4c4450),
      onSurfaceVariant: Color(0xfffff9fb),
      outline: Color(0xffd3c7d6),
      outlineVariant: Color(0xffd3c7d6),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe9e0e9),
      inverseOnSurface: Color(0xff000000),
      inversePrimary: Color(0xff43026b),
      primaryFixed: Color(0xfff5dfff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffe5bbff),
      onPrimaryFixedVariant: Color(0xff270041),
      secondaryFixed: Color(0xffffe1cb),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffffbd83),
      onSecondaryFixedVariant: Color(0xff261100),
      tertiaryFixed: Color(0xffffdfe7),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffb7cd),
      onTertiaryFixedVariant: Color(0xff350019),
      surfaceDim: Color(0xff161218),
      surfaceBright: Color(0xff3d373e),
      surfaceContainerLowest: Color(0xff110d13),
      surfaceContainerLow: Color(0xff1e1a20),
      surfaceContainer: Color(0xff221e24),
      surfaceContainerHigh: Color(0xff2d282f),
      surfaceContainerHighest: Color(0xff38333a),
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
