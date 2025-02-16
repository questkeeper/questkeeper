import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/categories/views/edit_category_bottom_sheet.dart';
import 'package:questkeeper/layout/utils/state_providers.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/task_list/views/edit_task_drawer.dart';

class CategoryDropdownField extends ConsumerStatefulWidget {
  const CategoryDropdownField({
    super.key,
    required this.onCategoryChanged,
    this.existingSpace,
    this.defaultCategoryId,
    this.useCurrentSpace = true,
  });

  final void Function(String?) onCategoryChanged;
  final String? defaultCategoryId;
  final Spaces? existingSpace;
  final bool useCurrentSpace;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoryDropdownFieldState();
}

class _CategoryDropdownFieldState extends ConsumerState<CategoryDropdownField> {
  late PageController _pageController;
  int _lastKnownPage = 0;
  String? categoryId;

  @override
  void initState() {
    super.initState();
    _pageController = ref.read(pageControllerProvider);
    _pageController.addListener(_onPageChanged);
    categoryId = widget.defaultCategoryId;
  }

  void _validateCategory() {
    // Schedule the validation for after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final categories =
          ref.read(categoriesManagerProvider).asData?.value ?? [];
      final targetSpace = widget.useCurrentSpace
          ? getCurrentSpace(ref) ?? widget.existingSpace
          : widget.existingSpace;

      final spaceCategories = categories
          .where((category) => category.spaceId == targetSpace?.id)
          .toList();

      if (categoryId != null && categoryId != "-1" && categoryId != "null") {
        final categoryExists = spaceCategories
            .any((category) => category.id.toString() == categoryId);
        if (!categoryExists) {
          setState(() {
            categoryId = null;
          });
          widget.onCategoryChanged(null);
        }
      }
    });
  }

  @override
  void didUpdateWidget(CategoryDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset category if space changes or if default category changes
    if (oldWidget.existingSpace?.id != widget.existingSpace?.id ||
        oldWidget.defaultCategoryId != widget.defaultCategoryId) {
      setState(() {
        categoryId = null;
      });
      widget.onCategoryChanged(null);
    }

    // Validate category whenever widget updates
    _validateCategory();
  }

  @override
  void dispose() {
    categoryId = null;
    widget.onCategoryChanged(null);
    _pageController.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    if (!mounted) return;
    setState(() {
      categoryId = null;
    });
    widget.onCategoryChanged(null);
    ref.read(contextPaneProvider.notifier).state = null;

    final newPage = _pageController.page?.round() ?? 0;
    if (_lastKnownPage != newPage) {
      _lastKnownPage = newPage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesManagerProvider);

    return categoriesAsync.when(
      data: (categories) {
        final targetSpace = widget.useCurrentSpace
            ? getCurrentSpace(ref) ?? widget.existingSpace
            : widget.existingSpace;

        final spaceCategories = categories
            .where((category) => category.spaceId == targetSpace?.id)
            .toList();

        final categoriesList = [
              const Categories(
                id: null,
                title: "No Category",
              ),
            ] +
            spaceCategories +
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
          value: categoryId ?? "null",
          onChanged: (newValue) {
            setState(() {
              categoryId = newValue;
            });
            if (newValue == "-1") {
              showCategoryBottomSheet(
                context: context,
                ref: ref,
                existingSpace: targetSpace,
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
      loading: () => const LinearProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
