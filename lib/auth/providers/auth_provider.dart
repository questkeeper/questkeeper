// auth_provider.dart
import 'package:assigngo_rewrite/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:assigngo_rewrite/auth/models/auth_state.dart';

class AuthNotifier extends StateNotifier<SignInState> {
  AuthNotifier() : super(SignInState(otpSent: false));

  final emailController = TextEditingController();
  final otpController = TextEditingController();

  Future<void> signIn() async {
    try {
      if (state.otpSent) {
        await supabase.auth.verifyOTP(
          email: emailController.text,
          token: otpController.text,
          type: OtpType.email,
          redirectTo: '/',
        );
      } else {
        await supabase.auth.signInWithOtp(
          email: emailController.text,
          shouldCreateUser: true,
        );
        state = state.copyWith(otpSent: true);
      }
    } catch (error) {
      state = state.copyWith(error: error.toString());
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, SignInState>((ref) {
  return AuthNotifier();
});
