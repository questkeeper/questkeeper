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
import 'package:questkeeper/task_list/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:questkeeper/task_list/subtasks/providers/subtasks_providers.dart';
import 'package:questkeeper/task_list/widgets/task_form.dart';

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

  final subtasksList = existingTask != null
      ? ref
          .read(subtasksManagerProvider.notifier)
          .getSubtasksByTaskId(existingTask.id!)
      : Future.value(<Subtask>[]);

  final TextEditingController nameController =
      TextEditingController(text: existingTask?.title);
  final TextEditingController descriptionController =
      TextEditingController(text: existingTask?.description);
  final isEditing = existingTask != null;

  Future<int?> createTask(Tasks task) async {
    final newTaskId = await ref.read(tasksManagerProvider.notifier).createTask(
          task.copyWith(
            spaceId: existingSpace?.id,
          ),
        );

    return newTaskId;
  }

  Future<void> updateTask(Tasks task) async {
    await ref.read(tasksManagerProvider.notifier).updateTask(
          task.copyWith(
            spaceId: existingSpace?.id,
          ),
        );
  }

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    isDismissible: true,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 1,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: _TaskBottomSheetContent(
              nameController: nameController,
              descriptionController: descriptionController,
              isEditing: isEditing,
              ref: ref,
              existingTask: existingTask,
              existingSpace: existingSpace,
              categoriesList: categoriesList,
              subtasksList: subtasksList,
              createTask: createTask,
              updateTask: updateTask,
              scrollController: controller,
            ),
          );
        },
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
  final Future<List<Subtask>> subtasksList;
  final Future<int?> Function(Tasks task) createTask;
  final Future<void> Function(Tasks task) updateTask;
  final ScrollController scrollController;

  const _TaskBottomSheetContent({
    required this.nameController,
    required this.descriptionController,
    required this.isEditing,
    required this.ref,
    this.existingTask,
    this.existingSpace,
    required this.categoriesList,
    required this.subtasksList,
    required this.createTask,
    required this.updateTask,
    required this.scrollController,
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
  void dispose() {
    widget.nameController.dispose();
    widget.descriptionController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  DateTime dueDate = DateTime.now();
  int? categoryId;
  List<Subtask> subtasks = [];
  final Map<String, TextEditingController> subtasksControllers = {};

  Future<void> _submitForm() async {
    setState(() {});

    if (formKey.currentState!.validate()) {
      final task = Tasks(
        title: widget.nameController.text,
        dueDate: DateTime.now(),
        description: widget.descriptionController.text,
        categoryId: categoryId,
      );

      if (widget.isEditing) {
        await widget.updateTask(task);
      }

      final taskId = widget.isEditing
          ? widget.existingTask!.id
          : await widget.createTask(task);

      if (taskId == null) {
        if (!mounted) return;
        SnackbarService.showErrorSnackbar(
          context,
          "Error creating task",
        );
        return;
      }

      subtasks = await widget.subtasksList;

      for (int i = 0; i < subtasks.length; i++) {
        final subtask = subtasks[i];
        String controllerId;

        if (subtasksControllers[subtask.id.toString()] == null) {
          controllerId = "tempkey-$i";
        } else {
          controllerId = subtask.id.toString();
        }

        subtasks[i] = subtask.copyWith(
            taskId: taskId,
            id: subtask.id,
            title: subtasksControllers[controllerId]!.text);
      }

      if (subtasks.isNotEmpty) {
        await widget.ref
            .read(subtasksManagerProvider.notifier)
            .upsertBulkSubtasks(subtasks);
      }

      if (!mounted) return;
      SnackbarService.showSuccessSnackbar(context, "Task created successfully");

      Navigator.of(context).pop();
    } else {
      if (!mounted) return;
      SnackbarService.showErrorSnackbar(
        context,
        "Error creating task",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView(
        controller: widget.scrollController,
        children: [
          const SizedBox(height: 16),
          Text(
            widget.isEditing ? 'Edit Task' : 'Create New Task',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TaskForm(
            onFormSubmitted: () {
              return Future.value();
            },
            formKey: formKey,
            titleController: widget.nameController,
            descriptionController: widget.descriptionController,
            dueDate: dueDate,
            categoriesList: widget.categoriesList,
            subtasks: widget.subtasksList,
            onDueDateChanged: (date) {
              setState(() {
                dueDate = date!;
              });
            },
            categoryId: widget.existingTask?.categoryId?.toString() ?? '',
            onCategoryChanged: (id) {
              setState(() {
                categoryId = int.tryParse(id!);
              });
            },
            subtasksControllers: subtasksControllers,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              await _submitForm();
            },
            child: Text(widget.isEditing ? 'Update Task' : 'Create Task'),
          ),
          const SizedBox(height: 16), // Add some padding at the bottom
        ],
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
