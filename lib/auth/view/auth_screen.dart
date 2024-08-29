import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase/supabase.dart';
import 'package:questkeeper/auth/widgets/supa_magic_auth.dart'
    show SupaMagicAuth; // Overriding the supa auth UI with own flow
import 'package:supabase_auth_ui/supabase_auth_ui.dart'
    show SupaSocialsAuth, SocialButtonVariant, OAuthProvider;
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSuccess(Session response) async {
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/home',
          (route) => false,
        );
      }
    }

    void onError(error) {
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
                "QuestKeeper",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SupaMagicAuth(
                redirectUrl: kIsWeb
                    ? "${Uri.base.toString()}/signin"
                    : 'questkeeper://signin',
                onSuccess: onSuccess,
                onError: onError,
              ),
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
                TextButton.icon(
                  icon: const Icon(LucideIcons.shield_alert),
                  onPressed: () {
                    launchUrl(Uri.parse("https://questkeeper.app/privacy"));
                  },
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
