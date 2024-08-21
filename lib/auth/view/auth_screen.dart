import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/auth/providers/auth_provider.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSuccess(Session response) async {
      debugPrint("Foreground notification options");
      await ref.read(authProvider.notifier).setFirebaseMessaging();
      debugPrint("Firebase messaging set");
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/home',
          (route) => false,
        );
      }
    }

    void onError(error) {
      debugPrint("Error: $error");
      SnackbarService.showErrorSnackbar(
        context,
        error.toString(),
      );
    }

    return Scaffold(
        body: Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        width: MediaQuery.of(context).size.width > 800
            ? MediaQuery.of(context).size.width * 0.75
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Quest Keeper",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),

            SupaMagicAuth(
              redirectUrl: kIsWeb
                  ? "${Uri.base.toString()}/signin"
                  : 'questkeeper://signin',
              onSuccess: onSuccess,
              onError: onError,
            ),

            SupaSocialsAuth(
              socialProviders: const [
                // OAuthProvider.apple,
                // OAuthProvider.google,
                OAuthProvider.discord
              ],
              socialButtonVariant: SocialButtonVariant.icon,
              colored: true,
              redirectUrl: kIsWeb ? null : 'questkeeper://signin',
              onSuccess: onSuccess,
              onError: onError,
            ),

            // Sign in with password option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/signin/password');
                  },
                  child: const Text('Sign In with Password'),
                ),
                // ),
                TextButton.icon(
                  icon: const Icon(Icons.launch_rounded),
                  onPressed: () {},
                  label: const Text("Privacy Policy"),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
