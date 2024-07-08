import 'dart:io';

import 'package:questkeeper/auth/providers/auth_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPasswordScreen extends ConsumerWidget {
  const SignInPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              controller: ref.read(authProvider.notifier).emailController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your Password',
              ),
              controller: ref.read(authProvider.notifier).otpController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FilledButton(
              onPressed: () {
                ref.read(authProvider.notifier).passwordSignIn().then((_) => {
                      if (authState.error == null)
                        {
                          FirebaseMessaging.instance.requestPermission(
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
                    });
              },
              child: const Text("Sign In"),
            ),
          ),
        ],
      ),
    );
  }
}
