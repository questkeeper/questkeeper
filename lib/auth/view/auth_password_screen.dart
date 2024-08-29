import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SignInPasswordScreen extends ConsumerWidget {
  const SignInPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSuccess(AuthResponse response) async {
      if (!response.session!.user.email!.endsWith("@questkeeper.app")) {
        return SnackbarService.showErrorSnackbar(
          context,
          'Not allowed to sign in with email',
        );
      }

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SupaEmailAuth(
            onToggleSignIn: (_) {
              Navigator.pop(context);
            },
            onError: onError,
            onSignInComplete: onSuccess,
            onSignUpComplete: (AuthResponse response) {
              Supabase.instance.client.auth.signOut();
              Navigator.pop(context);
              SnackbarService.showErrorSnackbar(
                context,
                'Not allowed to sign up with email',
              );
            },
          )
        ],
      ),
    );
  }
}
