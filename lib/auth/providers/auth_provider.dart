import 'package:appwrite/appwrite.dart';
import 'package:assigngo_rewrite/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assigngo_rewrite/auth/models/auth_state.dart';

class AuthNotifier extends StateNotifier<SignInState> {
  AuthNotifier(this.userId) : super(SignInState(otpSent: false));

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final String? userId;

  Future<void> signIn() async {
    try {
      if (state.otpSent) {
        await account.updateVerification(
          userId: userId!,
          secret: otpController.text,
        );
      } else {
        final response = await account.createEmailToken(
            userId: ID.unique(), email: emailController.text);
        state = state.copyWith(otpSent: true, userId: response.userId);
      }
    } catch (error) {
      state = state.copyWith(error: error.toString(), userId: null);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, SignInState>((ref) {
  return AuthNotifier(null);
});
