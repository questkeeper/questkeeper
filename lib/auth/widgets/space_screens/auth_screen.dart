import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/auth/providers/auth_page_controller_provider.dart';
import 'package:questkeeper/auth/widgets/supa_magic_auth.dart'
    as custom_auth; // Custom email auth implementation
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/settings/views/account/account_management_screen.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';

import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _showEmailAuth = false; // Hidden by default
  int _tapCount = 0;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Handle secret gesture to show email auth (tap QuestKeeper title 3 times)
  void _handleTitleTap() {
    setState(() {
      _tapCount++;
    });

    // Reset tap count after 2 seconds of no taps
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _tapCount = 0;
        });
      }
    });

    // Show email auth after 3 taps
    if (_tapCount >= 3) {
      setState(() {
        _showEmailAuth = true;
        _tapCount = 0;
      });
      SnackbarService.showInfoSnackbar(
        "Email authentication is deprecated but enabled for this session",
      );
    }
  }

  void onSuccess(Session response) async {
    try {
      final profile = await ref.read(profileManagerProvider.future);

      if (profile.isActive == true) {
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
          );
          SnackbarService.showSuccessSnackbar(
            "Welcome back, ${profile.username}!",
          );
          return;
        }
      } else {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const AccountManagementScreen(),
              settings: const RouteSettings(arguments: true),
            ),
          );
          SnackbarService.showErrorSnackbar(
            "Your account is inactive. Time to come back?",
          );
          return;
        }
      }

      throw Exception("Context not mounted");
    } catch (e) {
      if (mounted) {
        ref.read(authPageControllerProvider).nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
        SnackbarService.showInfoSnackbar(
          "Welcome to QuestKeeper!",
        );
        return;
      }
    }
  }

  void onError(Object? error) {
    debugPrint(error.toString());

    if (mounted) {
      // User friendly error message
      SnackbarService.showErrorSnackbar("An error occurred when signing in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        width: MediaQuery.of(context).size.width > 800
            ? MediaQuery.of(context).size.width * 0.75
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tappable title for secret gesture
            GestureDetector(
              onTap: _handleTitleTap,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Text(
                  "QuestKeeper",
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.left,
                ),
              ),
            ),

            // Terms of Service Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "By signing in, you agree to our ",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    TextSpan(
                      text: "Terms of Service",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(Uri.parse(
                              "https://questkeeper.app/privacy-policy"));
                        },
                    ),
                    TextSpan(
                      text: " and ",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    TextSpan(
                      text: "Privacy Policy",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(Uri.parse(
                              "https://questkeeper.app/privacy-policy"));
                        },
                    ),
                  ],
                ),
              ),
            ),

            // Email Auth (hidden by default, shown after secret gesture)
            if (_showEmailAuth)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      label: const Text("Back"),
                      onPressed: () {
                        setState(() {
                          _showEmailAuth = false;
                        });
                      },
                      icon: const Icon(LucideIcons.arrow_left),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Theme.of(context).colorScheme.error,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Email authentication is deprecated",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    custom_auth.SupaMagicAuth(
                      redirectUrl: kIsWeb
                          ? "${Uri.base.toString()}/signin"
                          : 'questkeeper://signin',
                      onSuccess: onSuccess,
                      onError: onError,
                    ),
                  ],
                ),
              ),

            if (!_showEmailAuth) ...[
              // Social Sign In using supabase_auth_ui
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: Column(
                  children: [
                    SupaSocialsAuth(
                      socialProviders: [
                        OAuthProvider.google,
                        if (Platform.isIOS || Platform.isMacOS)
                          OAuthProvider.apple,
                        OAuthProvider.discord,
                      ],
                      socialButtonVariant: SocialButtonVariant.iconAndText,
                      redirectUrl: kIsWeb
                          ? "${Uri.base.toString()}/signin"
                          : 'questkeeper://signin',
                      onSuccess: onSuccess,
                      onError: onError,
                      showSuccessSnackBar: false,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
