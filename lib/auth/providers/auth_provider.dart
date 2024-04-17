import 'package:appwrite/appwrite.dart';
import 'package:assigngo_rewrite/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assigngo_rewrite/auth/models/auth_state.dart';

class AuthNotifier extends StateNotifier<SignInState> {
  AuthNotifier(this.userId) : super(SignInState(otpSent: false));

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  String? userId;

  Future<void> signIn() async {
    try {
      if (state.otpSent && userId != null) {
        final response = await account.createSession(
          userId: userId!,
          secret: otpController.text,
        );

        if (!response.current) {
          throw Exception("OTP is incorrect");
        }
      } else {
        if (state.otpSent) {
          throw Exception("User ID is null");
        }
        userId = ID.unique();
        final response = await account.createEmailToken(
            userId: userId!, email: emailController.text);
        state = state.copyWith(otpSent: true, userId: response.userId);

        userId = response.userId;
      }
    } catch (error) {
      state = state.copyWith(error: error.toString(), userId: null);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, SignInState>((ref) {
  return AuthNotifier(null);
});
