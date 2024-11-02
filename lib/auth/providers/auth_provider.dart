import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthNotifier {
  AuthNotifier() : super();
  SupabaseClient supabase = Supabase.instance.client;
  bool _firebaseMessagingInitialized = false;

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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

  // THIS IS ONLy FOR DEBUG PURPOSES
  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentDeviceId = prefs.getString("deviceId");

    if (currentDeviceId != null) {
      await supabase.from("profiles").delete().eq("deviceId", currentDeviceId);
    }

    await FirebaseMessaging.instance.deleteToken();

    prefs.remove("deviceId");
    prefs.remove("token");
  }

  // Set up FCM
  Future<void> setFirebaseMessaging() async {
    if (_firebaseMessagingInitialized) {
      return;
    }

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

      if (token != null && _firebaseMessagingInitialized == false) {
        await _saveToken(token);
        _firebaseMessagingInitialized = true;
      } else {
        // Handle the case where the initial token retrieval fails.
        // You might want to retry later or provide user feedback.
      }
    }
  }
}
