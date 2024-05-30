import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assigngo_rewrite/auth/models/auth_state.dart';
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

  // Set up FCM
  Future<void> setFirebaseMessaging() async {
    debugPrint('Setting up FCM');
    String? token;
    await FirebaseMessaging.instance.requestPermission(
      provisional: true,
    );

    if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      token = await FirebaseMessaging.instance.getAPNSToken();
      debugPrint("APNS Token: $token");
    } else {
      token = await FirebaseMessaging.instance.getToken();
      debugPrint("FCM Token: $token");
    }

    if (token == null) {
      debugPrint('Token is null');
      return;
    }

    debugPrint("Making a call to createPushTarget");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final currentDeviceId = prefs.getString("deviceId");

    if (currentDeviceId != null) {
      await supabase.from("profiles").update({
        "fcm_token": token,
      }).eq("device_id", currentDeviceId);
    } else {
      final deviceId = await supabase.from("profiles").insert({
        "fcm_token": token,
      }).select();

      prefs.setString("deviceId", deviceId.first["device_id"]);
    }

    debugPrint("Token: $token, Device ID: ${prefs.getString("deviceId")}");
  }
}
