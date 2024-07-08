import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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

  final emailController = TextEditingController();
  final otpController = TextEditingController();

  Future<void> signIn() async {
    try {
      if (state.otpSent) {
        final res = await supabase.auth.verifyOTP(
          email: emailController.text,
          token: otpController.text,
          type: OtpType.email,
        );

        if (res.user == null) {
          throw Exception("OTP is incorrect");
        }
      } else {
        if (state.otpSent) {
          throw Exception("User ID is null");
        }
        await supabase.auth.signInWithOtp(email: emailController.text);
        state = state.copyWith(otpSent: true, userId: emailController.text);
      }
    } catch (error) {
      state = state.copyWith(error: error.toString(), userId: null);
    }
  }

  Future<void> passwordSignIn() async {
    try {
      // final response = await account.createEmailPasswordSession(
      //     email: emailController.text, password: otpController.text);

      // if (!response.current) {
      //   throw Exception("Password is incorrect");
      // }

      // state = state.copyWith(otpSent: true, userId: response.userId);
      // userId = response.userId;
    } catch (error) {
      state = state.copyWith(error: error.toString(), userId: null);
    }
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentDeviceId = prefs.getString("deviceId");
    String? currentToken = prefs.getString("token");

    debugPrint("Current Token: $currentToken, New Token: $token");

    if (currentToken == token) {
      return;
    }

    debugPrint("Making a call to createPushTarget");

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
    debugPrint('Setting up FCM');
    String? token;
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      provisional: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        // Handle new or refreshed APNs token
        saveToken(token);
      });

      // if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
      // String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      // if (apnsToken != null) {
      //   saveToken(apnsToken);
      // } else {
      // Handle the case where the initial token retrieval fails.
      // You might want to retry later or provide user feedback.
      //   debugPrint("APNS Token is null");
      // }

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
        debugPrint("FCM Token is null");
      }
    }
    // } else {
    //   debugPrint("User declined permission");
    // }

    // if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
    //   FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    //     alert: true,
    //     badge: true,
    //     sound: true,
    //   );

    //   token = await FirebaseMessaging.instance.getAPNSToken();
    //   debugPrint("APNS Token: $token");
    // } else {
    //   token = await FirebaseMessaging.instance.getToken();
    //   debugPrint("FCM Token: $token");
    // }

    // if (token == null) {
    //   debugPrint('Token is null');
    //   return;
    // }

    // debugPrint("Making a call to createPushTarget");

    // SharedPreferences prefs = await SharedPreferences.getInstance();

    // final currentDeviceId = prefs.getString("deviceId");

    // if (currentDeviceId != null) {
    //   await supabase.from("profiles").update({
    //     "fcm_token": token,
    //   }).eq("device_id", currentDeviceId);
    // } else {
    //   final deviceId = await supabase.from("profiles").insert({
    //     "fcm_token": token,
    //   }).select();

    //   prefs.setString("deviceId", deviceId.first["device_id"]);
    // }

    // debugPrint("Token: $token, Device ID: ${prefs.getString("deviceId")}");
  }
}
