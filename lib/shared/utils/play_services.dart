import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PlayServicesUtil {
  static const MethodChannel _channel =
      MethodChannel('app.questkeeper/play_services');

  static Future<bool> isPlayServicesAvailable() async {
    if (!Platform.isAndroid) return false;

    try {
      final bool isAvailable =
          await _channel.invokeMethod('isPlayServicesAvailable');
      return isAvailable;
    } catch (e) {
      debugPrint('Error checking Play Services: $e');
      return false;
    }
  }
}
