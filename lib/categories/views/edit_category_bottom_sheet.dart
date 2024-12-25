import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/categories/widgets/delete_category_dialog.dart';
import 'package:questkeeper/shared/extensions/color_extensions.dart';
import 'package:questkeeper/shared/widgets/filled_loading_button.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';

void showCategoryBottomSheet({
  required BuildContext context,
  required WidgetRef ref,
  Categories? existingCategory,
  Spaces? existingSpace,
}) {
  final TextEditingController nameController =
      TextEditingController(text: existingCategory?.title);
  final isEditing = existingCategory != null;
  Color? initialColor =
      existingCategory?.color != null ? existingCategory!.color!.toColor : null;

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    isDismissible: true,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: Colors
        .transparent, // Make the background transparent to show the gradient
    builder: (BuildContext context) {
      return _CategoryBottomSheetContent(
        nameController: nameController,
        isEditing: isEditing,
        initialColor: initialColor,
        ref: ref,
        existingCategory: existingCategory,
        existingSpace: existingSpace,
      );
    },
  );
}

class _CategoryBottomSheetContent extends StatefulWidget {
  final TextEditingController nameController;
  final bool isEditing;
  final Color? initialColor;
  final WidgetRef ref;
  final Categories? existingCategory;
  final Spaces? existingSpace;

  const _CategoryBottomSheetContent({
    required this.nameController,
    required this.isEditing,
    required this.initialColor,
    required this.ref,
    this.existingCategory,
    this.existingSpace,
  });

  @override
  _CategoryBottomSheetContentState createState() =>
      _CategoryBottomSheetContentState();
}

class _CategoryBottomSheetContentState
    extends State<_CategoryBottomSheetContent> {
  Color? selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  void _updateColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selectedColor?.withOpacity(0.6).blendWith(Colors.black) ??
            Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 16,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.isEditing ? 'Edit Category' : 'Create New Category',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: widget.nameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
              ),
            ),

            const SizedBox(height: 16),

            // Button to show the color picker dialog
            FocusScope(
              canRequestFocus: false,
              child: ColorPicker(
                onColorChanged: _updateColor,
                color: selectedColor ?? Colors.blue,
              ),
            ),

            Flex(
              direction: Axis.horizontal,
              children: [
                widget.isEditing
                    ? IconButton(
                        onPressed: () {
                          if (widget.isEditing) {
                            deleteCategory() {
                              Navigator.of(context).pop();
                              widget.ref
                                  .read(categoriesManagerProvider.notifier)
                                  .deleteCategory(widget.existingCategory!);
                              SnackbarService.showSuccessSnackbar(
                                'Category deleted successfully',
                              );
                            }

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DeleteCategoryDialog(
                                      category: widget.existingCategory!,
                                      deleteCategory: deleteCategory);
                                });
                          }
                        },
                        iconSize: 24,
                        icon: const Icon(
                          LucideIcons.trash,
                          color: Colors.redAccent,
                        ),
                      )
                    : const SizedBox(),
                SizedBox(width: widget.isEditing ? 16 : 0),
                Expanded(
                  child: FilledLoadingButton(
                    child: Text(widget.isEditing
                        ? 'Update Category'
                        : 'Create Category'),
                    onPressed: () async {
                      if (widget.nameController.text.isNotEmpty) {
                        if (widget.isEditing) {
                          await widget.ref
                              .read(categoriesManagerProvider.notifier)
                              .updateCategory(
                                widget.existingCategory!.copyWith(
                                    title: widget.nameController.text,
                                    spaceId: widget.existingCategory?.spaceId,
                                    color: selectedColor?.hex),
                              );
                        } else {
                          await widget.ref
                              .read(categoriesManagerProvider.notifier)
                              .createCategory(Categories(
                                  title: widget.nameController.text,
                                  spaceId: widget.existingSpace?.id,
                                  color: selectedColor?.hex));
                        }
                        if (context.mounted) Navigator.pop(context);
                        widget.nameController.clear();
                        if (context.mounted) {
                          SnackbarService.showSuccessSnackbar(
                            widget.isEditing
                                ? 'Category updated successfully'
                                : 'Category created successfully',
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
