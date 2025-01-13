import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/categories/views/edit_category_bottom_sheet.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';

class CategoryDropdownField extends ConsumerStatefulWidget {
  const CategoryDropdownField({
    super.key,
    required this.onCategoryChanged,
    this.existingSpace,
    this.defaultCategoryId,
  });

  final void Function(String?) onCategoryChanged;
  final String? defaultCategoryId;
  final Spaces? existingSpace;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoryDropdownFieldState();
}

class _CategoryDropdownFieldState extends ConsumerState<CategoryDropdownField> {
  @override
  Widget build(BuildContext context) {
    // Watch the provider to get the latest categories
    final categoriesAsync = ref.watch(categoriesManagerProvider);

    return categoriesAsync.when(
      data: (categories) {
        // Combine predefined categories with the dynamic list
        final categoriesList = [
              const Categories(
                id: null,
                title: "No Category",
              ),
            ] +
            categories
                .where(
                    (category) => category.spaceId == widget.existingSpace?.id)
                .toList() +
            [
              const Categories(title: "Create New Category", id: -1),
            ];

        return DropdownButtonFormField2(
          dropdownStyleData: DropdownStyleData(
            maxHeight: 400,
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
            offset: const Offset(-20, 0),
          ),
          value:
              widget.defaultCategoryId == null || widget.defaultCategoryId == ""
                  ? categoriesList.first.id.toString()
                  : widget.defaultCategoryId,
          onChanged: (newValue) {
            if (newValue == "-1") {
              showCategoryBottomSheet(
                context: context,
                ref: ref,
                existingSpace: widget.existingSpace,
              );
            }
            widget.onCategoryChanged(newValue);
          },
          isExpanded: true,
          items: categoriesList
              .map(
                (category) => DropdownMenuItem(
                  value: category.id.toString(),
                  child: Text(category.title),
                ),
              )
              .toList(),
        );
      },
      loading: () => const LinearProgressIndicator(), // Show a loading spinner
      error: (error, stackTrace) => Text('Error: $error'), // Handle errors
    );
  }
}
