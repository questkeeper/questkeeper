import 'package:appwrite/models.dart';
import 'package:assigngo_rewrite/auth/view/auth_screen.dart';
import 'package:assigngo_rewrite/constants.dart';
import 'package:assigngo_rewrite/tabs/tabview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentSessionProvider = FutureProvider<User?>((ref) async {
  try {
    final user = await account.get();
    return user;
  } catch (error) {
    return null;
  }
});

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSessionAsync = ref.watch(currentSessionProvider);

    return currentSessionAsync.when(
      data: (session) => session != null ? const TabView() : const AuthScreen(),
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }
}
