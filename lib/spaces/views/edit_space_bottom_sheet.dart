import 'package:assigngo_rewrite/shared/widgets/snackbar.dart';
import 'package:assigngo_rewrite/spaces/models/spaces_model.dart';
import 'package:assigngo_rewrite/spaces/providers/spaces_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showSpaceBottomSheet({
  required BuildContext context,
  required WidgetRef ref,
  required PageController pageController,
  Spaces? existingSpace,
}) {
  final TextEditingController nameController =
      TextEditingController(text: existingSpace?.title);
  final isEditing = existingSpace != null;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEditing ? 'Edit Space' : 'Create New Space',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Space Name',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  if (isEditing) {
                    await ref.read(spacesManagerProvider.notifier).updateSpace(
                          existingSpace.copyWith(title: nameController.text),
                        );
                  } else {
                    await ref.read(spacesManagerProvider.notifier).createSpace(
                          Spaces(title: nameController.text),
                        );
                  }
                  if (context.mounted) Navigator.pop(context);
                  nameController.clear();

                  if (!isEditing) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (pageController.hasClients) {
                        pageController.animateToPage(0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    });
                  }

                  if (context.mounted) {
                    SnackbarService.showSuccessSnackbar(
                      context,
                      isEditing
                          ? 'Space updated successfully'
                          : 'Space created successfully',
                    );
                  }
                }
              },
              child: Text(isEditing ? 'Update Space' : 'Create Space'),
            ),
          ],
        ),
      );
    },
  );
}
