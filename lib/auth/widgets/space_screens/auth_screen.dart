import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:questkeeper/auth/providers/auth_page_controller_provider.dart';
import 'package:questkeeper/auth/widgets/supa_magic_auth.dart'
    show SupaMagicAuth; // Overriding the supa auth UI with own flow
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/settings/views/account/account_management_screen.dart';
import 'package:questkeeper/shared/extensions/string_extensions.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isLoading = false;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _nativeGoogleSignIn() async {
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '479691835174-o5i59ui07vtj7r3n45h38hjeuq1s764e.apps.googleusercontent.com';

    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId =
        '479691835174-82kej9lnri53rffa25im0a5q312hsn3h.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<void> _signInWithProvider(OAuthProvider provider) async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (provider == OAuthProvider.apple) {
        final rawNonce = supabase.auth.generateRawNonce();
        final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: hashedNonce,
        );

        final idToken = credential.identityToken;
        if (idToken == null) {
          throw const AuthException(
              'Could not find ID Token from generated credential.');
        }

        await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.apple,
          idToken: idToken,
          nonce: rawNonce,
        );
      } else if (provider == OAuthProvider.google &&
          ((!kIsWasm || !kIsWeb) && (Platform.isAndroid || Platform.isIOS))) {
        await _nativeGoogleSignIn();
      } else {
        await supabase.auth.signInWithOAuth(
          provider,
          redirectTo:
              kIsWeb ? "${Uri.base.toString()}/signin" : 'questkeeper://signin',
        );
      }
    } catch (e) {
      if (mounted) {
        if (e.runtimeType == AuthException) {
          if ((e as AuthException).code == "access_denied") {
            SnackbarService.showInfoSnackbar("Authentication cancelled");
            return;
          }
        }

        if (e.runtimeType == SignInWithAppleAuthorizationException &&
            (e as SignInWithAppleAuthorizationException).code ==
                AuthorizationErrorCode.canceled) {
          SnackbarService.showInfoSnackbar("Authorization cancelled");
          return;
        }

        SnackbarService.showErrorSnackbar(
            "Failed to sign in with ${provider.name}");

        debugPrint(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
        return;
      }
    }
  }

  void onError(error) {
    debugPrint(error.toString());

    if (mounted) {
      // User friendly error message
      SnackbarService.showErrorSnackbar("An error occurred when signing in");
    }
  }

  Widget _buildSocialButton({
    required String assetPath,
    required OAuthProvider provider,
    required String label,
    required Color color,
  }) {
    return Tooltip(
      message: 'Continue with $label',
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _isLoading ? null : () => _signInWithProvider(provider),
        child: Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SvgPicture.asset(
            assetPath,
            fit: BoxFit.contain,
            colorFilter: provider == OAuthProvider.google
                ? null
                : const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
          ),
        ),
      ),
    );
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text(
                "QuestKeeper",
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.left,
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
            // Email Auth
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
              child: SupaMagicAuth(
                redirectUrl: kIsWeb
                    ? "${Uri.base.toString()}/signin"
                    : 'questkeeper://signin',
                onSuccess: onSuccess,
                onError: onError,
              ),
            ),
            // Social Sign In Buttons
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('or continue with'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        assetPath: 'assets/auth/google_logo.svg',
                        provider: OAuthProvider.google,
                        label: 'Google',
                        color: "#F2F2F2".toColor(),
                      ),
                      if (Platform.isIOS || Platform.isMacOS) ...[
                        const SizedBox(width: 8),
                        _buildSocialButton(
                          assetPath: 'assets/auth/apple_logo.svg',
                          provider: OAuthProvider.apple,
                          label: 'Apple',
                          color: Colors.black,
                        ),
                      ],
                      const SizedBox(width: 8),
                      _buildSocialButton(
                        assetPath: 'assets/auth/discord_logo.svg',
                        provider: OAuthProvider.discord,
                        color: "#5865F2".toColor(),
                        label: 'Discord',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
