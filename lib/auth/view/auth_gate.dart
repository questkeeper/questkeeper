import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:questkeeper/auth/providers/auth_state_provider.dart';
import 'package:questkeeper/auth/view/auth_spaces.dart';
import 'package:questkeeper/shared/screens/onboarding_page.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';
import 'package:questkeeper/tabs/tabview.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool isOnboarded = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      SharedPreferencesManager prefs = SharedPreferencesManager.instance;

      setState(() {
        isOnboarded = prefs.getBool("onboarded") ?? false;
      });

      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    if (authState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return authState.isAuthenticated ?? false
        ? const TabView()
        : !isOnboarded
            ? const OnboardingPage()
            : const AuthSpaces();
  }
}
