import 'package:assigngo_rewrite/task_list/models/tasks_model.dart';
import 'package:assigngo_rewrite/task_list/providers/current_task_provider.dart';
import 'package:assigngo_rewrite/task_list/providers/tasks_provider.dart';
import 'package:assigngo_rewrite/task_list/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:assigngo_rewrite/task_list/widgets/category_dropdown_field.dart';
import 'package:assigngo_rewrite/task_list/widgets/date_time_picker.dart';
import 'package:assigngo_rewrite/shared/utils/format_date.dart';
import 'package:assigngo_rewrite/shared/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskItemScreen extends ConsumerStatefulWidget {
  const TaskItemScreen({super.key});

  @override
  ConsumerState<TaskItemScreen> createState() => _TaskItemScreenState();
}

class _TaskItemScreenState extends ConsumerState<TaskItemScreen> {
  @override
  void initState() {
    super.initState();

    if (ref.read(currentTaskProvider).task == null) {
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    ref.read(currentTaskProvider.notifier).onDispose();
  }

  void _updateTask(Tasks task) {
    ref.read(tasksProvider.notifier).updateTask(task);
  }

  void _updateTaskCategory(Tasks task) {
    if (task.categoryId == -1) {
      task = task.copyWith(categoryId: null);
    }
    ref.read(currentTaskProvider.notifier).updateTaskCategory(task.categoryId);
    ref.read(tasksProvider.notifier).updateTask(task);
  }

  void _deleteTask(Tasks task) {
    ref.read(tasksProvider.notifier).deleteTask(task);
    ref.read(currentTaskProvider.notifier).setCurrentTask(null);
    Navigator.of(context).pop();
  }

  void _subtaskComplete(Subtask subtask) {
    subtask = subtask.copyWith(completed: !subtask.completed);
    ref.read(currentTaskProvider.notifier).updateSubtask(subtask);
  }

  void _updateSubtask(Subtask subtask) {
    ref.read(currentTaskProvider.notifier).updateSubtask(subtask);
  }

  void _createSubtask(Tasks task) async {
    final subtask = Subtask(
      title: "New Subtask",
      taskId: task.id!,
    );

    await ref.read(currentTaskProvider.notifier).addSubtask(subtask);
  }

  void setReadOnly(bool value) {
    SnackbarService.showInfoSnackbar(
        context,
        !value
            ? "Tap a field to edit it"
            : "You are no longer editing the assignment");

    ref.read(currentTaskProvider.notifier).readOnly = value;
  }

  @override
  Widget build(BuildContext context) {
    bool readOnly = ref.watch(currentTaskProvider).readOnly;
    ref.watch(currentTaskProvider).fetchSubtasksForCurrentTask();
    final currentTask = ref.watch(currentTaskProvider).task;
    final subtasks = ref.watch(currentTaskProvider).subtasks;
    final currentCategory = ref.watch(currentTaskProvider).category;
    final categoriesList = ref.watch(currentTaskProvider).allCategories;

    final platformBrightness = MediaQuery.of(context).platformBrightness;
    final size = MediaQuery.of(context).size;

    if (currentTask == null) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: platformBrightness == Brightness.dark
              ? CupertinoColors.darkBackgroundGray
              : CupertinoColors.lightBackgroundGray,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        ),
        child: const Center(
          child: Text("No task selected"),
        ),
      );
    }
    // Local variables to store the current assignment's categories, starred, and completed status
    // Set<Categories> categories = currentTask.categories.toSet();
    bool isStar = currentTask.starred;
    bool isComp = currentTask.completed;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: platformBrightness == Brightness.dark
              ? CupertinoColors.darkBackgroundGray
              : CupertinoColors.lightBackgroundGray,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            size.width < 800
                ? const SizedBox()
                : ActionButtons(
                    deleteTask: _deleteTask,
                    updateTask: _updateTask,
                    currentTask: currentTask,
                    size: size,
                    isStar: isStar,
                    isComp: isComp,
                    setCurrentTaskNull: () {
                      ref
                          .read(currentTaskProvider.notifier)
                          .setCurrentTask(null);
                    },
                    setReadOnly: setReadOnly,
                    readOnly: readOnly,
                  ),

            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   physics: const ClampingScrollPhysics(),
            //   child: Wrap(
            //     spacing: 8.0,
            //     children: Categories.values
            //         .map((category) => FilterChip(
            //             selected: categories.contains(category),
            //             selectedColor: const Color(0xFFa86fd1),
            //             showCheckmark: false,
            //             deleteIcon: const Icon(Icons.close),
            //             label: Text(
            //               category.toString().split('.').last,
            //               style:
            //                   Theme.of(context).textTheme.bodySmall?.copyWith(
            //                         fontWeight: FontWeight.bold,
            //                       ),
            //             ),
            //             onSelected: (bool value) {
            //               if (value) {
            //                 categories.add(category);
            //               } else {
            //                 categories.remove(category);
            //               }

            //               final Task updatedTask = currentTask.copyWith(
            //                   categories: categories.toList());

            //               _updateTask(updatedTask);
            //             }))
            //         .toList(),
            //   ),
            // ),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
              alignment: Alignment.centerLeft,
              child: TextField(
                readOnly: readOnly,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: currentTask.title,
                  hintStyle: Theme.of(context).textTheme.headlineLarge,
                ),
                style: Theme.of(context).textTheme.headlineLarge,
                onSubmitted: (String value) {
                  final Tasks updatedTask = currentTask.copyWith(title: value);
                  _updateTask(updatedTask);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 8.0),
              alignment: Alignment.centerLeft,
              child: readOnly == true
                  ? Text(
                      currentCategory?.title ?? "No category",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  : CategoryDropdownField(
                      categoriesList: categoriesList,
                      onCategoryChanged: (id) {
                        setState(() {
                          final Tasks updatedTask = currentTask.copyWith(
                            categoryId: int.parse(id!),
                          );
                          _updateTaskCategory(updatedTask);
                        });
                      },
                      defaultCategoryId: currentCategory?.id.toString(),
                    ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 8.0),
              alignment: Alignment.centerLeft,
              child: TextField(
                readOnly: readOnly,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: currentTask.description != null &&
                          currentTask.description!.isNotEmpty
                      ? currentTask.description
                      : "Description here..",
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                onSubmitted: (String value) {
                  final Tasks updatedTask =
                      currentTask.copyWith(description: value);
                  _updateTask(updatedTask);
                },
              ),
            ),
            InkWell(
              onTap: () async {
                if (readOnly == true) {
                  return;
                }
                await showDateTimePicker(
                  context,
                  currentTask.dueDate,
                  (DateTime selectedDateTime) {
                    final Tasks updatedTask =
                        currentTask.copyWith(dueDate: selectedDateTime);
                    _updateTask(updatedTask);
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Due ${formatDate(currentTask.dueDate)}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    "Subtasks",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_box_outlined),
                    onPressed: () {
                      _createSubtask(currentTask);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 100,
              child: ListView.builder(
                itemCount: subtasks?.length ?? 0,
                itemBuilder: (context, index) {
                  final subtask = subtasks?[index];
                  return CheckboxListTile(
                    enableFeedback: true,
                    subtitle: subtask?.priority != null
                        ? Text(
                            "Priority: ${subtask!.priority}",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.amber),
                          )
                        : null,
                    value: subtask?.completed,
                    title: readOnly
                        ? Text(subtask!.title,
                            style: Theme.of(context).textTheme.bodyLarge)
                        : TextField(
                            readOnly: readOnly,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: subtask!.title,
                              hintStyle: Theme.of(context).textTheme.bodyLarge,
                            ),
                            style: Theme.of(context).textTheme.bodyLarge,
                            onSubmitted: (String value) {
                              final Subtask updatedSubtask =
                                  subtask.copyWith(title: value);
                              _updateSubtask(updatedSubtask);
                            },
                          ),
                    onChanged: (bool? value) {
                      try {
                        if (value == null) {
                          return;
                        }
                        _subtaskComplete(subtask);
                      } catch (error) {
                        debugPrint("Error completing subtask: $error");
                      }
                    },
                  );
                },
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            size.width > 800 ? const SizedBox() : const Divider(),
            size.width > 800
                ? const SizedBox()
                : ActionButtons(
                    updateTask: _updateTask,
                    deleteTask: _deleteTask,
                    currentTask: currentTask,
                    setReadOnly: setReadOnly,
                    size: size,
                    isStar: isStar,
                    isComp: isComp,
                    readOnly: readOnly,
                    setCurrentTaskNull: () {
                      ref
                          .read(currentTaskProvider.notifier)
                          .setCurrentTask(null);
                    },
                  ),
            SizedBox(height: MediaQuery.of(context).padding.top + 10),
          ],
        ),
      ),
    );
  }
}

class ActionButtons extends StatefulWidget {
  const ActionButtons({
    super.key,
    required this.updateTask,
    required this.currentTask,
    required this.isStar,
    required this.isComp,
    required this.size,
    required this.deleteTask,
    required this.setCurrentTaskNull,
    required this.setReadOnly,
    required this.readOnly,
  });

  final Tasks? currentTask;
  final void Function(Tasks assignment) updateTask;
  final void Function(Tasks assignment) deleteTask;
  final void Function(bool readOnly) setReadOnly;
  final Size size;
  final bool isStar, isComp, readOnly;
  final void Function() setCurrentTaskNull;

  @override
  ActionButtonsState createState() => ActionButtonsState();
}

class ActionButtonsState extends State<ActionButtons> {
  @override
  Widget build(BuildContext context) {
    bool isStar = widget.isStar;
    bool isComp = widget.isComp;
    var newTask = widget.currentTask;

    final isModal = ModalRoute.of(context) is PopupRoute;
    return Row(
      // space evenly to take up the full width
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (isModal) {
              Navigator.of(context).pop();
              dispose();
            }
            widget.setCurrentTaskNull();
          },
        ),
        Visibility(
          maintainSize: false,
          visible: widget.size.width > 800,
          child: const Spacer(),
        ),
        IconButton(
          icon: Icon(widget.readOnly ? Icons.edit : Icons.edit_off),
          onPressed: () {
            widget.setReadOnly(
              !widget.readOnly,
            );
          },
        ),
        IconButton(
          icon:
              isStar ? const Icon(Icons.star) : const Icon(Icons.star_outline),
          color: Colors.amber,
          onPressed: () {
            isStar = !isStar;
            widget.updateTask(newTask!.copyWith(starred: isStar));
          },
        ),
        IconButton(
          icon: widget.currentTask!.completed
              ? const Icon(Icons.cancel_presentation)
              : const Icon(Icons.check),
          color: widget.currentTask!.completed ? Colors.red : Colors.green,
          onPressed: () {
            isComp = !isComp;
            widget.updateTask(newTask!.copyWith(completed: isComp));
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.red,
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      content: Text(
                        "Are you sure you want to delete ${widget.currentTask!.title}?",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      actions: [
                        FilledButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel")),
                        FilledButton(
                            onPressed: () {
                              widget.deleteTask(widget.currentTask!);

                              isModal ? Navigator.of(context).pop() : null;

                              dispose();
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.redAccent),
                            ),
                            child: const Text("Delete")),
                      ],
                    ));
          },
        ),
      ],
    );
  }
}
