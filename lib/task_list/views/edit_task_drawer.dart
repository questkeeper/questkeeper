import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:questkeeper/shared/widgets/filled_loading_button.dart';
import 'package:questkeeper/shared/widgets/show_drawer.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/tabs/new_user_onboarding/providers/onboarding_provider.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';
import 'package:questkeeper/task_list/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:questkeeper/task_list/subtasks/providers/subtasks_providers.dart';
import 'package:questkeeper/task_list/widgets/action_buttons.dart';
import 'package:questkeeper/task_list/widgets/task_form.dart';

Widget getTaskDrawerContent({
  required BuildContext context,
  required WidgetRef ref,
  Tasks? existingTask,
}) {
  final PageController pageController = ref.read(pageControllerProvider);
  final spacesList = ref.read(spacesManagerProvider).asData;
  final existingSpace = getCurrentSpace(ref, pageController, spacesList);

  final subtasksList = existingTask != null
      ? ref
          .read(subtasksManagerProvider.notifier)
          .getSubtasksByTaskId(existingTask.id!)
      : Future.value(<Subtask>[]);

  final isEditing = existingTask != null;

  Future<int?> createTask(Tasks task) async {
    task = task.copyWith(spaceId: existingSpace?.id);
    final newTaskId =
        await ref.read(tasksManagerProvider.notifier).createTask(task);

    return newTaskId;
  }

  Future<void> updateTask(Tasks task) async {
    await ref.read(tasksManagerProvider.notifier).updateTask(
          task.copyWith(
            spaceId: existingSpace?.id,
          ),
        );
  }

  return _TaskBottomSheetContent(
    initialTitle: existingTask?.title ?? '',
    initialDescription: existingTask?.description ?? '',
    isEditing: isEditing,
    ref: ref,
    existingTask: existingTask,
    existingSpace: existingSpace,
    spacesList: spacesList,
    subtasksList: subtasksList,
    createTask: createTask,
    updateTask: updateTask,
  );
}

void showTaskDrawer({
  required BuildContext context,
  required WidgetRef ref,
  Tasks? existingTask,
}) {
  final PageController pageController = ref.read(pageControllerProvider);
  final spacesList = ref.read(spacesManagerProvider).asData;
  final existingSpace = getCurrentSpace(ref, pageController, spacesList);

  final subtasksList = existingTask != null
      ? ref
          .read(subtasksManagerProvider.notifier)
          .getSubtasksByTaskId(existingTask.id!)
      : Future.value(<Subtask>[]);

  final isEditing = existingTask != null;

  Future<int?> createTask(Tasks task) async {
    task = task.copyWith(spaceId: existingSpace?.id);
    final newTaskId =
        await ref.read(tasksManagerProvider.notifier).createTask(task);

    return newTaskId;
  }

  Future<void> updateTask(Tasks task) async {
    await ref.read(tasksManagerProvider.notifier).updateTask(
          task.copyWith(
            spaceId: existingSpace?.id,
          ),
        );
  }

  // Open the drawer using Navigator
  showDrawer(
    context: context,
    key: existingTask?.id.toString() ?? 'new-task',
    child: _TaskBottomSheetContent(
      initialTitle: existingTask?.title ?? '',
      initialDescription: existingTask?.description ?? '',
      isEditing: isEditing,
      ref: ref,
      existingTask: existingTask,
      existingSpace: existingSpace,
      spacesList: spacesList,
      subtasksList: subtasksList,
      createTask: createTask,
      updateTask: updateTask,
    ),
  );
}

class _TaskBottomSheetContent extends StatefulWidget {
  final String initialTitle;
  final String initialDescription;
  final bool isEditing;
  final WidgetRef ref;
  final Tasks? existingTask;
  final Spaces? existingSpace;
  final AsyncValue<List<Spaces>>? spacesList;
  final Future<List<Subtask>> subtasksList;
  final Future<int?> Function(Tasks task) createTask;
  final Future<void> Function(Tasks task) updateTask;

  const _TaskBottomSheetContent({
    required this.initialTitle,
    required this.initialDescription,
    required this.isEditing,
    required this.ref,
    this.existingTask,
    this.existingSpace,
    required this.spacesList,
    required this.subtasksList,
    required this.createTask,
    required this.updateTask,
  });

  @override
  _TaskBottomSheetContentState createState() => _TaskBottomSheetContentState();
}

class _TaskBottomSheetContentState extends State<_TaskBottomSheetContent> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  final Map<String, TextEditingController> subtasksControllers = {};
  final formKey = GlobalKey<FormState>();
  late DateTime dueDate;
  int? categoryId;
  int? spaceId;
  bool hasCategoryChanged = false;
  bool hasSpaceChanged = false;
  List<Subtask> subtasks = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialTitle);
    descriptionController =
        TextEditingController(text: widget.initialDescription);
    dueDate = widget.existingTask?.dueDate ?? DateTime.now();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    subtasksControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _cleanup() {
    if (!Navigator.canPop(context)) {
      nameController.clear();
      descriptionController.clear();
      subtasksControllers.forEach((_, controller) => controller.clear());
      setState(() {
        subtasks.clear();
        dueDate = DateTime.now();
        categoryId = null;
        spaceId = null;
        hasCategoryChanged = false;
        hasSpaceChanged = false;
      });
    }
  }

  Future<void> _submitForm() async {
    setState(() {});

    if (formKey.currentState!.validate()) {
      Tasks task = Tasks(
        title: nameController.text,
        dueDate: dueDate,
        description: descriptionController.text,
        categoryId:
            hasCategoryChanged ? categoryId : widget.existingTask?.categoryId,
      );

      if (widget.isEditing && widget.existingTask != null) {
        final currTask = widget.existingTask;
        task = task.copyWith(
          id: currTask!.id,
          updatedAt: currTask.updatedAt,
          createdAt: currTask.createdAt,
        );

        await widget.updateTask(task);
      }

      final taskId = widget.isEditing
          ? widget.existingTask!.id
          : await widget.createTask(task);

      if (taskId == null) {
        if (!mounted) return;
        SnackbarService.showErrorSnackbar(
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
      SnackbarService.showSuccessSnackbar(
        widget.isEditing
            ? "Task updated successfully"
            : "Task created successfully",
      );

      if (Navigator.canPop(context)) Navigator.of(context).pop();

      if (!widget.isEditing &&
          widget.ref.read(onboardingProvider).hasCreatedTask == false &&
          widget.ref.read(onboardingProvider).isOnboardingComplete == false) {
        widget.ref.read(onboardingProvider.notifier).markTaskCreated();

        if (context.mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    } else {
      if (!mounted) return;
      SnackbarService.showErrorSnackbar(
        "Error creating task",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    titleController: nameController,
                    descriptionController: descriptionController,
                    dueDate: dueDate,
                    spacesList: widget.spacesList,
                    subtasks: widget.subtasksList,
                    currentSpaceId: widget.existingSpace?.id,
                    existingSpace: widget.existingSpace,
                    categoryId:
                        widget.existingTask?.categoryId?.toString() ?? '',
                    onSpaceChanged: (id) {
                      hasSpaceChanged = true;
                      setState(() {
                        spaceId = int.tryParse(id!);
                      });
                    },
                    onDueDateChanged: (date) {
                      setState(() {
                        dueDate = date!;
                      });
                    },
                    onCategoryChanged: (id) {
                      hasCategoryChanged = true;
                      setState(() {
                        if (id == null.toString()) {
                          categoryId = null;
                        } else {
                          categoryId = int.tryParse(id!);
                        }
                      });
                    },
                    subtasksControllers: subtasksControllers,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          !widget.isEditing
              ? const SizedBox()
              : ActionButtons(
                  currentTask: widget.existingTask!,
                  toggleStarTask: (task) async {
                    await widget.ref
                        .read(tasksManagerProvider.notifier)
                        .toggleStar(task);
                  },
                  toggleCompleteTask: (task) async {
                    await widget.ref
                        .read(tasksManagerProvider.notifier)
                        .toggleComplete(task);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  deleteTask: (task) async {
                    await widget.ref
                        .read(tasksManagerProvider.notifier)
                        .deleteTask(task);

                    if (context.mounted && Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  size: MediaQuery.of(context).size,
                ),
          SizedBox(
            width: double.infinity,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel'),
                      onPressed: () => {
                        _cleanup(),
                        if (Navigator.canPop(context)) Navigator.pop(context),
                      },
                    ),
                    const SizedBox(width: 8), // Gap between buttons
                    Expanded(
                      child: FilledLoadingButton(
                        onPressed: () async {
                          await _submitForm();
                        },
                        child: Text(
                          widget.isEditing ? 'Update Task' : 'Create Task',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Spaces? getCurrentSpace(WidgetRef ref, PageController pageController,
    AsyncValue<List<Spaces>>? spacesList) {
  if (spacesList != null && spacesList.asData == null) return null;

  final spaces = spacesList?.asData!.value;
  if (spaces == null) return null;

  final currentPage = pageController.page?.round() ?? 0;

  if (currentPage < spaces.length) {
    return spaces[currentPage];
  } else {
    return spaces.last;
  }
}
