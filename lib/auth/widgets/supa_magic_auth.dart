import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// UI component to create magic link login form
class SupaMagicAuth extends StatefulWidget {
  /// `redirectUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? redirectUrl;

  /// Method to be called when the auth action is success
  final void Function(Session response) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  const SupaMagicAuth({
    super.key,
    this.redirectUrl,
    required this.onSuccess,
    this.onError,
  });

  @override
  State<SupaMagicAuth> createState() => _SupaMagicAuthState();
}

class _SupaMagicAuthState extends State<SupaMagicAuth> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _passwordVisible = false;
  late final SupabaseClient supabase = Supabase.instance.client;
  late final StreamSubscription<AuthState> _gotrueSubscription;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _gotrueSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null && mounted) {
        widget.onSuccess(session);
      }
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _gotrueSubscription.cancel();
    super.dispose();
  }

  Future<void> _loginOtp(BuildContext context) async {
    try {
      await supabase.auth.signInWithOtp(
        email: _email.text,
        emailRedirectTo: widget.redirectUrl,
      );

      if (context.mounted) {
        SnackbarService.showInfoSnackbar(
            context, "Check your email for a link to login!");
      }
    } on AuthException catch (error) {
      if (widget.onError == null && context.mounted) {
        SnackbarService.showErrorSnackbar(
          context,
          error.message,
        );
      } else {
        widget.onError?.call(error);
      }
    } catch (error) {
      if (widget.onError == null && context.mounted) {
        SnackbarService.showErrorSnackbar(
            context, "An unexpected error occurred: $error");
      } else {
        widget.onError?.call(error);
      }
    }
  }

  Future<void> _loginPassword(BuildContext context) async {
    try {
      await supabase.auth.signInWithPassword(
        email: _email.text,
        password: _password.text,
      );
    } on AuthException catch (error) {
      if (widget.onError == null && context.mounted) {
        SnackbarService.showErrorSnackbar(context, error.message);
      } else {
        widget.onError?.call(error);
      }
    } catch (error) {
      if (widget.onError == null && context.mounted) {
        SnackbarService.showErrorSnackbar(
            context, "An unexpected error occurred: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !EmailValidator.validate(_email.text)) {
                return "Please enter a valid email";
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _passwordVisible = value.endsWith("@questkeeper.app");
              });
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(LucideIcons.mail),
              label: Text("Enter your email"),
            ),
            controller: _email,
          ),

          // Padding
          const SizedBox(height: 8),

          // Password field - visible for @questkeeper.app emails
          _passwordVisible
              ? TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  decoration: const InputDecoration(
                    prefixIcon: Icon(LucideIcons.lock),
                    label: Text("Test account password"),
                  ),
                  controller: _password,
                )
              : const SizedBox(),

          // Padding
          const SizedBox(height: 16),

          FilledButton(
            child: (_isLoading)
                ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                      strokeWidth: 1.5,
                    ),
                  )
                : const Text(
                    "Continue with Email",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              setState(() {
                _isLoading = true;
              });

              if (_passwordVisible && _password.text.isNotEmpty) {
                await _loginPassword(context);
              } else {
                await _loginOtp(context);
              }

              setState(() {
                _isLoading = false;
              });
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
