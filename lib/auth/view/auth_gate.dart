import 'package:questkeeper/auth/view/auth_spaces.dart';
import 'package:questkeeper/tabs/tabview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final currentSessionProvider = FutureProvider<UserResponse?>((ref) async {
  try {
    final user = await Supabase.instance.client.auth.getUser();
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
      data: (session) => session != null ? const TabView() : const AuthSpaces(),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text('Error: $error'),
    );
  }
}
