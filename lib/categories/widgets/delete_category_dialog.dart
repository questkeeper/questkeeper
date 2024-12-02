import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:flutter/material.dart';

class DeleteCategoryDialog extends StatelessWidget {
  const DeleteCategoryDialog({
    super.key,
    required this.category,
    required this.deleteCategory,
  });

  final Categories category;
  final void Function() deleteCategory;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete ${category.title}?"),
      content: Text(
        "Are you sure you want to delete it? Tasks will not be deleted.",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: [
        Expanded(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.redAccent),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              deleteCategory();
            },
            child: const Text("Delete"),
          ),
        ),
      ],
    );
  }
}
