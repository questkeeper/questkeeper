import 'dart:io';

import 'package:assigngo_rewrite/shared/utils/onesignal/onesignal_mobile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assigngo_rewrite/auth/models/auth_state.dart';
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
  void setOneSignal() async {
    final userId = supabase.auth.currentUser?.id;
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      OneSignalMobile().loginExternalUserId(userId!);
    }
  }
}
