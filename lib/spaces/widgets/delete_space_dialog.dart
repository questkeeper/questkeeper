import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:flutter/material.dart';

class DeleteSpaceDialog extends StatelessWidget {
  const DeleteSpaceDialog({
    super.key,
    required this.space,
    required this.deleteSpace,
  });

  final Spaces space;
  final void Function() deleteSpace;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Delete Space"),
        content: Text(
          "Are you sure you want to delete this space? This will delete all your tasks and categories in this space.",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteSpace();
            },
            child: const Text("Delete"),
          ),
        ]);
  }
}
