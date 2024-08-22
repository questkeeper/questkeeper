import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/auth/models/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authProvider = StateNotifierProvider<AuthNotifier, SignInState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<SignInState> {
  AuthNotifier() : super(SignInState(otpSent: false));
  SupabaseClient supabase = Supabase.instance.client;

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentDeviceId = prefs.getString("deviceId");
    String? currentToken = prefs.getString("token");

    if (currentToken == token) {
      return;
    }

    if (currentDeviceId != null) {
      await supabase.from("profiles").update({
        "previousToken": currentToken,
        "token": token,
        "deviceType": Platform.operatingSystem,
      }).eq("deviceId", currentDeviceId);
    } else {
      final deviceId = await supabase.from("profiles").insert({
        "token": token,
      }).select();

      prefs.setString("deviceId", deviceId.first["deviceId"]);
    }

    prefs.setString("token", token);
  }

  // THIS IS ONLy FOR DEBUG PURPOSES
  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentDeviceId = prefs.getString("deviceId");

    if (currentDeviceId != null) {
      await supabase.from("profiles").update({
        "token": null,
      }).eq("deviceId", currentDeviceId);
    }

    await FirebaseMessaging.instance.deleteToken();

    prefs.remove("deviceId");
    prefs.remove("token");
  }

  // Set up FCM
  Future<void> setFirebaseMessaging() async {
    // await clearToken();
    String? token;
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      provisional: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.provisional ||
        settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        // Handle new or refreshed APNs token
        saveToken(token);
      });

      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      // } else {
      token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        saveToken(token);
      } else {
        // Handle the case where the initial token retrieval fails.
        // You might want to retry later or provide user feedback.
      }
    }
  }
}
