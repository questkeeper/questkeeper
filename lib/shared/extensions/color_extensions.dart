import 'package:flutter/painting.dart';

extension ColorExtensions on Color {
  // This method creates a new color by adjusting the hue of the current color
  Color withHueOffset(double offset) {
    final hsl = HSLColor.fromColor(this);
    final newHue = (hsl.hue + offset) % 360;
    return hsl.withHue(newHue).toColor();
  }

  Color convertFromHex(String hex) {
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }

  List<Color> toCardGradientColor() {
    return [
      withOpacity(0.7),
      withHueOffset(5).withOpacity(0.7),
      withHueOffset(-35).withOpacity(0.7),
    ];
  }
}
