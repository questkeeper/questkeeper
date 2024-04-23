import 'package:appwrite/appwrite.dart';
import 'package:assigngo_rewrite/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assigngo_rewrite/auth/models/auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, SignInState>((ref) {
  return AuthNotifier(null);
});

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

  Future<void> passwordSignIn() async {
    print(emailController.text);
    print(otpController.text);
    try {
      final response = await account.createEmailPasswordSession(
          email: emailController.text, password: otpController.text);

      if (!response.current) {
        throw Exception("Password is incorrect");
      }

      state = state.copyWith(otpSent: true, userId: response.userId);
      userId = response.userId;
    } catch (error) {
      state = state.copyWith(error: error.toString(), userId: null);
    }
  }

  // Set up FCM
  void setFirebaseMessaging() async {
    debugPrint('Setting up FCM');
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.getAPNSToken();
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint(token);

    if (token == null) {
      debugPrint('Token is null');
      return;
    }

    debugPrint("Making a call to createPushTarget");
    final result = await account.createPushTarget(
        targetId: ID.unique(),
        identifier: token,
        providerId: '661e90e9001427890121');

    debugPrint(result.identifier);
  }
}
