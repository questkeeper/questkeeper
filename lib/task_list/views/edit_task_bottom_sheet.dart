import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';

void showTaskBottomSheet({
  required BuildContext context,
  required WidgetRef ref,
  Tasks? existingTask,
}) {
  final PageController pageController = ref.read(pageControllerProvider);
  final spacesList = ref.read(spacesManagerProvider).asData;
  final existingSpace = getCurrentSpace(ref, pageController, spacesList);

  final categoriesList =
      ref.read(categoriesManagerProvider.notifier).fetchCategories().then(
            (value) => value
                .where((element) => element.spaceId == existingSpace?.id)
                .toList(),
          );

  final TextEditingController nameController =
      TextEditingController(text: existingTask?.title);
  final TextEditingController descriptionController =
      TextEditingController(text: existingTask?.description);
  final isEditing = existingTask != null;

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    isDismissible: true,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return _TaskBottomSheetContent(
        nameController: nameController,
        descriptionController: descriptionController,
        isEditing: isEditing,
        ref: ref,
        existingTask: existingTask,
        existingSpace: existingSpace,
        categoriesList: categoriesList,
      );
    },
  );
}

class _TaskBottomSheetContent extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final bool isEditing;
  final WidgetRef ref;
  final Tasks? existingTask;
  final Spaces? existingSpace;
  final Future<List<Categories>> categoriesList;

  const _TaskBottomSheetContent({
    required this.nameController,
    required this.descriptionController,
    required this.isEditing,
    required this.ref,
    this.existingTask,
    this.existingSpace,
    required this.categoriesList,
  });

  @override
  _TaskBottomSheetContentState createState() => _TaskBottomSheetContentState();
}

class _TaskBottomSheetContentState extends State<_TaskBottomSheetContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
              widget.isEditing ? 'Edit Task' : 'Create New Task',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              widget.existingSpace!.title,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: widget.nameController,
              decoration: InputDecoration(
                labelText: widget.existingTask?.title ?? 'Task Name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                if (widget.nameController.text.isNotEmpty) {
                  if (widget.isEditing) {
                    await widget.ref
                        .read(tasksManagerProvider.notifier)
                        .updateTask(
                          widget.existingTask!.copyWith(
                            title: widget.nameController.text,
                            description: widget.descriptionController.text,
                            spaceId: widget.existingSpace?.id,
                          ),
                        );
                  } else {
                    await widget.ref
                        .read(tasksManagerProvider.notifier)
                        .createTask(
                          Tasks(
                            title: widget.nameController.text,
                            spaceId: widget.existingSpace?.id,
                            description: widget.descriptionController.text,
                            dueDate: DateTime.now(),
                          ),
                        );
                  }
                  if (context.mounted) Navigator.pop(context);
                  widget.nameController.clear();
                  if (context.mounted) {
                    SnackbarService.showSuccessSnackbar(
                      context,
                      widget.isEditing
                          ? 'Task updated successfully'
                          : 'Task created successfully',
                    );
                  }
                }
              },
              child: Text(widget.isEditing ? 'Update Task' : 'Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}

Spaces? getCurrentSpace(WidgetRef ref, PageController pageController,
    AsyncValue<List<Spaces>>? spacesList) {
  if (spacesList!.asData == null) return null;

  final spaces = spacesList.asData!.value;
  final currentPage = pageController.page?.round() ?? 0;

  if (currentPage < spaces.length) {
    return spaces[currentPage];
  } else {
    return spaces.last;
  }
}
