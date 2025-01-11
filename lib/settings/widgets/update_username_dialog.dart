import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/shared/extensions/text_formatter_extensions.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';

class UpdateUsernameDialog extends ConsumerWidget {
  final TextEditingController controller = TextEditingController();

  UpdateUsernameDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Update Username'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter your new username'),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller,
            maxLength: 20,
            decoration: const InputDecoration(
              label: Text("Username"),
            ),
            inputFormatters: [
              LowerCaseTextFormatter(),
              AlphaNumericTextFormatter(),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            if (controller.text.isEmpty ||
                controller.text.length < 3 ||
                controller.text.length > 20) {
              SnackbarService.showErrorSnackbar(
                  "Username must be between 3 and 20 characters");
              return;
            }

            final response = await ref
                .read(profileManagerProvider.notifier)
                .updateUsername(controller.text);

            if (context.mounted) {
              Navigator.pop(context);
              if (response.success) {
                SnackbarService.showSuccessSnackbar(response.message);
              } else {
                SnackbarService.showErrorSnackbar(response.message);
              }
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
