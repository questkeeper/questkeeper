import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/shared/extensions/platform_extensions.dart';
import 'package:questkeeper/shared/utils/mixpanel/mixpanel_manager.dart';
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
import 'package:questkeeper/task_list/widgets/action_buttons.dart';
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

  if (PlatformExtensions.isMobile) {
    MixpanelManager.instance.track("AddTaskScreen", properties: {
      "action": "Open add task screen",
    });
  }

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    isDismissible: true,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: _TaskBottomSheetContent(
          nameController: nameController,
          descriptionController: descriptionController,
          isEditing: isEditing,
          ref: ref,
          existingTask: existingTask,
          existingSpace: existingSpace,
          categoriesList: categoriesList,
          spacesList: spacesList,
          subtasksList: subtasksList,
          createTask: createTask,
          updateTask: updateTask,
        ),
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
  final AsyncValue<List<Spaces>>? spacesList;
  final Future<List<Subtask>> subtasksList;
  final Future<int?> Function(Tasks task) createTask;
  final Future<void> Function(Tasks task) updateTask;

  const _TaskBottomSheetContent({
    required this.nameController,
    required this.descriptionController,
    required this.isEditing,
    required this.ref,
    this.existingTask,
    this.existingSpace,
    required this.categoriesList,
    required this.spacesList,
    required this.subtasksList,
    required this.createTask,
    required this.updateTask,
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
  late DateTime dueDate = widget.existingTask?.dueDate ?? DateTime.now();
  int? categoryId;
  int? spaceId;
  bool hasCategoryChanged = false;
  bool hasSpaceChanged = false;
  List<Subtask> subtasks = [];
  final Map<String, TextEditingController> subtasksControllers = {};

  Future<void> _submitForm() async {
    setState(() {});

    if (formKey.currentState!.validate()) {
      Tasks task = Tasks(
        title: widget.nameController.text,
        dueDate: dueDate,
        description: widget.descriptionController.text,
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

      MixpanelManager.instance.track("AddTaskScreen", properties: {
        "action": "Task created",
        "id": taskId,
      });

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
                    titleController: widget.nameController,
                    descriptionController: widget.descriptionController,
                    dueDate: dueDate,
                    categoriesList: widget.categoriesList,
                    spacesList: widget.spacesList,
                    subtasks: widget.subtasksList,
                    currentSpaceId: widget.existingSpace?.id,
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
                  },
                  deleteTask: (task) async {
                    await widget.ref
                        .read(tasksManagerProvider.notifier)
                        .deleteTask(task);
                  },
                  size: MediaQuery.of(context).size,
                ),
          SizedBox(
            width: double.infinity,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: FilledButton(
                  onPressed: () async {
                    await _submitForm();
                  },
                  child: Text(widget.isEditing ? 'Update Task' : 'Create Task'),
                ),
              ),
            ),
          ),
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
