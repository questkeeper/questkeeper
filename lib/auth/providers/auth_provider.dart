import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';
import 'package:questkeeper/shared/utils/play_services.dart';
import 'package:questkeeper/shared/notifications/local_notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthNotifier {
  AuthNotifier() : super();
  SupabaseClient supabase = Supabase.instance.client;
  bool _firebaseMessagingInitialized = false;
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();

  bool get isLocalNotificationsSupported {
    if (kIsWeb) return false;
    // All desktop/mobile platforms support local notifications
    return Platform.isAndroid ||
        Platform.isMacOS ||
        Platform.isLinux ||
        Platform.isIOS ||
        Platform.isWindows;
  }

  Future<bool> get isFCMSupported async {
    // Only Android (with Play Services), iOS and Web support FCM
    if (kIsWeb || Platform.isIOS) return true;
    if (Platform.isAndroid) {
      return await PlayServicesUtil.isPlayServicesAvailable();
    }
    return false;
  }

  Future<void> _saveToken(String token) async {
    if (!await isFCMSupported) return;

    SharedPreferencesManager prefs = SharedPreferencesManager.instance;
    String? currentDeviceId = prefs.getString("deviceId");
    String? currentToken = prefs.getString("token");
    final deviceInfo = await (DeviceInfoPlugin()).deviceInfo;

    if (currentToken == token) {
      return;
    }

    if (_firebaseMessagingInitialized == true) {
      return;
    }

    final deviceInfoData = Map<String, dynamic>.from({
      "deviceType": deviceInfo.data["model"],
      "deviceName": deviceInfo.data["name"],
      "deviceOs": deviceInfo.data["systemName"],
      "deviceOsVersion": deviceInfo.data["systemVersion"],
    });

    if (currentDeviceId != null) {
      await supabase.from("profiles").update({
        "previousToken": currentToken,
        "token": token,
        ...deviceInfoData,
      }).eq("deviceId", currentDeviceId);
    } else {
      final deviceId = await supabase.from("profiles").insert({
        "token": token,
        ...deviceInfoData,
      }).select();

      prefs.setString("deviceId", deviceId.first["deviceId"]);
    }

    prefs.setString("firebaseToken", token);
  }

  Future<void> clearToken() async {
    if (!await isFCMSupported) return;

    SharedPreferencesManager prefs = SharedPreferencesManager.instance;
    String? currentDeviceId = prefs.getString("deviceId");

    if (currentDeviceId != null) {
      await supabase.from("profiles").delete().eq("deviceId", currentDeviceId);
    }

    await FirebaseMessaging.instance.deleteToken();

    await prefs.remove("deviceId");
    await prefs.remove("token");
  }

  Future<void> setFirebaseMessaging() async {
    // If FCM is already initialized, we're done
    if (_firebaseMessagingInitialized) {
      return;
    }

    // Check if FCM is supported
    final fcmSupported = await isFCMSupported;

    // If FCM isn't supported, fall back to local notifications
    if (!fcmSupported) {
      if (isLocalNotificationsSupported) {
        await _initializeLocalNotifications();
      }
      return;
    }

    // Try to initialize FCM
    try {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        provisional: true,
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.provisional ||
          settings.authorizationStatus == AuthorizationStatus.authorized) {
        await FirebaseMessaging.instance.getAPNSToken();
        final token = await FirebaseMessaging.instance.getToken();

        if (token != null) {
          await _saveToken(token);
          _firebaseMessagingInitialized = true;

          // If FCM initialization succeeded, cancel any local notifications
          if (isLocalNotificationsSupported) {
            await _localNotificationService.cancelAllNotifications();
          }
          return;
        }
      }

      // If we get here, FCM failed to initialize (permissions denied or no token)
      _fallbackToLocalNotifications();
    } catch (e) {
      debugPrint("Error initializing FCM: $e");
      _fallbackToLocalNotifications();
    }
  }

  void _fallbackToLocalNotifications() {
    debugPrint(
        "FCM initialization failed, falling back to local notifications");
    if (isLocalNotificationsSupported) {
      _initializeLocalNotifications();
    }
  }

  Future<void> _initializeLocalNotifications() async {
    if (!isLocalNotificationsSupported) return;

    final initSuccessful = await _localNotificationService.initialize();
    if (initSuccessful == true) {
      await _localNotificationService.syncNotificationsFromSchedule();
    }
  }
}
