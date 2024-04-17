import 'package:assigngo_rewrite/constants.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Settings'),
        const Text('Coming soon...'),
        ElevatedButton(
            onPressed: () async {
              await account.deleteSession(sessionId: "current");
              Navigator.pushReplacementNamed(context, "/signin");
            },
            child: const Text('Sign out')),
      ],
    );
  }
}
