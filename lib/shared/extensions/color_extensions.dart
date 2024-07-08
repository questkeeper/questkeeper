import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  // This method creates a new color by adjusting the hue of the current color
  Color withHueOffset(double offset) {
    final hsl = HSLColor.fromColor(this);
    final newHue = (hsl.hue + offset) % 360;
    return hsl.withHue(newHue).toColor();
  }

  Color convertFromHex(String hex) {
    if (hex.length == 6 && !hex.startsWith("0x")) {
      hex = "FF$hex"; // Add alpha channel if not provided
    }
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }

  List<Color> toCardGradientColor() {
    return [
      withOpacity(0.7).blendWith(Colors.black),
      withHueOffset(5).withOpacity(0.7).blendWith(Colors.black),
      withHueOffset(-35).withOpacity(0.7).blendWith(Colors.black),
    ];
  }

  Color blendWith(Color backgroundColor) {
    double alpha = opacity;
    return Color.fromRGBO(
      (red * alpha + backgroundColor.red * (1 - alpha)).round(),
      (green * alpha + backgroundColor.green * (1 - alpha)).round(),
      (blue * alpha + backgroundColor.blue * (1 - alpha)).round(),
      1,
    );
  }
}
