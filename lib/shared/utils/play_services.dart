import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_api_availability/google_api_availability.dart';

class PlayServicesUtil {
  static Future<bool> isPlayServicesAvailable() async {
    if (!Platform.isAndroid) return false;

    try {
      final availability = await GoogleApiAvailability.instance
          .checkGooglePlayServicesAvailability();
      return availability == GooglePlayServicesAvailability.success;
    } catch (e) {
      debugPrint('Error checking Play Services: $e');
      return false;
    }
  }
}
