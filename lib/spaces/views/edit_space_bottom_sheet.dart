import 'package:assigngo_rewrite/shared/extensions/color_extensions.dart';
import 'package:assigngo_rewrite/shared/widgets/snackbar.dart';
import 'package:assigngo_rewrite/spaces/models/spaces_model.dart';
import 'package:assigngo_rewrite/spaces/providers/page_provider.dart';
import 'package:assigngo_rewrite/spaces/providers/spaces_provider.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showSpaceBottomSheet({
  required BuildContext context,
  required WidgetRef ref,
  Spaces? existingSpace,
}) {
  final TextEditingController nameController =
      TextEditingController(text: existingSpace?.title);
  final isEditing = existingSpace != null;
  Color? initialColor =
      existingSpace?.color != null ? existingSpace!.color!.toColor : null;

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    isDismissible: true,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: Colors
        .transparent, // Make the background transparent to show the gradient
    builder: (BuildContext context) {
      return _SpaceBottomSheetContent(
        nameController: nameController,
        isEditing: isEditing,
        initialColor: initialColor,
        ref: ref,
        existingSpace: existingSpace,
      );
    },
  );
}

class _SpaceBottomSheetContent extends StatefulWidget {
  final TextEditingController nameController;
  final bool isEditing;
  final Color? initialColor;
  final WidgetRef ref;
  final Spaces? existingSpace;

  const _SpaceBottomSheetContent({
    required this.nameController,
    required this.isEditing,
    required this.initialColor,
    required this.ref,
    this.existingSpace,
  });

  @override
  _SpaceBottomSheetContentState createState() =>
      _SpaceBottomSheetContentState();
}

class _SpaceBottomSheetContentState extends State<_SpaceBottomSheetContent> {
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
    final pageController = widget.ref.watch(pageControllerProvider);
    final currentPageIndex = pageController.page?.toInt() ?? 0;

    return Container(
      decoration: selectedColor != null
          ? BoxDecoration(
              gradient: LinearGradient(
                colors: selectedColor!.toCardGradientColor(),
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            )
          : BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
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
              widget.isEditing ? 'Edit Space' : 'Create New Space',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: widget.nameController,
              decoration: InputDecoration(
                labelText: widget.existingSpace?.title ?? 'Space Name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            // Button to show the color picker dialog
            ColorPicker(
              onColorChanged: _updateColor,
              color: selectedColor ?? Colors.blue,
            ),
            FilledButton(
              onPressed: () async {
                if (widget.nameController.text.isNotEmpty) {
                  if (widget.isEditing) {
                    await widget.ref
                        .read(spacesManagerProvider.notifier)
                        .updateSpace(
                          widget.existingSpace!.copyWith(
                              title: widget.nameController.text,
                              color: selectedColor?.hex),
                        );
                  } else {
                    await widget.ref
                        .read(spacesManagerProvider.notifier)
                        .createSpace(Spaces(
                            title: widget.nameController.text,
                            color: selectedColor?.hex));
                  }
                  if (context.mounted) Navigator.pop(context);
                  widget.nameController.clear();

                  if (!widget.isEditing) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (pageController.hasClients) {
                        pageController.animateToPage(currentPageIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    });
                  } else {
                    if (context.mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (pageController.hasClients) {
                          pageController.jumpToPage(currentPageIndex);
                        }
                      });
                    }
                  }

                  if (context.mounted) {
                    SnackbarService.showSuccessSnackbar(
                      context,
                      widget.isEditing
                          ? 'Space updated successfully'
                          : 'Space created successfully',
                    );
                  }
                }
              },
              child: Text(widget.isEditing ? 'Update Space' : 'Create Space'),
            ),
          ],
        ),
      ),
    );
  }
}
