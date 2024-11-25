import 'dart:io';

import 'package:flutter/foundation.dart';

extension PlatformExtensions on Platform {
  static bool get isMobile => Platform.isAndroid || Platform.isIOS;
  static bool get isMobileOrWeb =>
      Platform.isAndroid || Platform.isIOS || kIsWeb;
  static bool get isDesktop =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}
