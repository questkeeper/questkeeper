import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assigngo_rewrite/auth/providers/auth_provider.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

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
              readOnly: authState.otpSent,
            ),
          ),
          if (authState.otpSent)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  hintText: 'Enter the OTP',
                ),
                controller: ref.read(authProvider.notifier).otpController,
              ),
            ),
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
                          if (authState.otpSent)
                            Navigator.of(context).pushNamed(
                              '/home',
                            ),
                        })
                    .catchError((error) => {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error: Check your OTP code?'),
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
        ],
      ),
    );
  }
}
