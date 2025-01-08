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
      withValues(alpha: 0.7).blendWith(Colors.black),
      withHueOffset(5).withValues(alpha: 0.7).blendWith(Colors.black),
      withHueOffset(-35).withValues(alpha: 0.7).blendWith(Colors.black),
    ];
  }

  Color blendWith(Color backgroundColor) {
    return Color.alphaBlend(this, backgroundColor);
  }
}
