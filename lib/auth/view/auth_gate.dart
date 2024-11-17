import 'package:questkeeper/auth/providers/auth_state_provider.dart';
import 'package:questkeeper/auth/view/auth_spaces.dart';
import 'package:questkeeper/tabs/tabview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    if (authState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return authState.isAuthenticated ?? false
        ? const TabView()
        : const AuthSpaces();
  }
}
