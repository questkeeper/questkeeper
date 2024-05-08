import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assigngo_rewrite/auth/providers/auth_provider.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
        body: Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        width: MediaQuery.of(context).size.width > 800
            ? MediaQuery.of(context).size.width * 0.75
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              controller: ref.read(authProvider.notifier).emailController,
              readOnly: authState.otpSent,
            ),
            if (authState.otpSent)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'OTP',
                    hintText: 'Enter the OTP',
                  ),
                  controller: ref.read(authProvider.notifier).otpController,
                ),
              ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(authProvider.notifier)
                          .signIn()
                          .then((_) => {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(authState.otpSent
                                        ? 'OTP verified'
                                        : 'OTP sent'),
                                  ),
                                ),
                                if (authState.otpSent &&
                                    authState.error == null)
                                  {
                                    // Request push notification permission
                                    FirebaseMessaging.instance
                                        .requestPermission(
                                      provisional: true,
                                    ),

                                    if (Platform.isIOS || Platform.isMacOS)
                                      {
                                        FirebaseMessaging.instance
                                            .setForegroundNotificationPresentationOptions(
                                          alert: true,
                                          badge: true,
                                          sound: true,
                                        ),
                                      },

                                    ref
                                        .read(authProvider.notifier)
                                        .setFirebaseMessaging(),

                                    Navigator.of(context).popAndPushNamed(
                                      '/home',
                                    ),
                                  }
                              })
                          .catchError((error) => {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Error: Check your OTP code?'),
                                  ),
                                ),
                              });
                    },
                    child: const Text('Sign In'),
                  ),
                ),
                if (authState.error != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error: ${authState.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                // Sign in with password option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signin/password');
                      },
                      child: const Text('Sign In with Password'),
                    ),
                    // ),
                    TextButton.icon(
                      icon: const Icon(Icons.launch_rounded),
                      onPressed: () {},
                      label: const Text("Privacy Policy"),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
