import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/auth/providers/auth_page_controller_provider.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';

class UsernameScreen extends ConsumerWidget {
  final TextEditingController controller = TextEditingController();
  UsernameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        width: MediaQuery.of(context).size.width > 800
            ? MediaQuery.of(context).size.width * 0.75
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Choose a username",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controller,
                maxLength: 20,
                decoration: const InputDecoration(
                  prefixIcon: Icon(LucideIcons.user),
                  label: Text("Enter your username"),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "This will be your public username that will be displayed on leaderboards and to your friends.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FilledButton(
                onPressed: () async {
                  if (controller.text.isEmpty ||
                      controller.text.length < 3 ||
                      controller.text.length > 20) {
                    SnackbarService.showErrorSnackbar(context,
                        "Username must be between 3 and 20 characters");
                    return;
                  }

                  final response = await ref
                      .read(profileManagerProvider.notifier)
                      .updateUsername(controller.text);

                  if (response.success) {
                    ref.read(authPageControllerProvider).nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                    if (context.mounted) {
                      SnackbarService.showSuccessSnackbar(
                          context, response.message);
                    }
                  } else {
                    if (context.mounted) {
                      SnackbarService.showErrorSnackbar(
                          context, response.message);
                    }
                  }
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
