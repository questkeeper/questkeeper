import 'package:assigngo_rewrite/main.dart';
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
              await supabase.auth.signOut();
              Navigator.pushReplacementNamed(context, "/signin");
            },
            child: const Text('Sign out')),
      ],
    );
  }
}
