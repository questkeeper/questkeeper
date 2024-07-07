import 'package:flutter/painting.dart';

extension HexColor on String {
  Color toColor() {
    String hex = replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex"; // Add alpha channel if not provided
    }
    if (hex.length == 8) {
      return Color(int.parse("0x$hex"));
    } else {
      throw const FormatException("Invalid hex color format");
    }
  }
}
