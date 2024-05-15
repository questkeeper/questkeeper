import 'package:assigngo_rewrite/categories/models/categories_model.dart';
import 'package:assigngo_rewrite/categories/providers/categories_provider.dart';
import 'package:assigngo_rewrite/task_list/models/tasks_model.dart';
import 'package:assigngo_rewrite/task_list/providers/current_task_provider.dart';
import 'package:assigngo_rewrite/task_list/providers/tasks_provider.dart';
import 'package:assigngo_rewrite/task_list/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:assigngo_rewrite/task_list/widgets/date_time_picker.dart';
import 'package:assigngo_rewrite/shared/utils/format_date.dart';
import 'package:assigngo_rewrite/shared/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  void _updateAssignment(Tasks assignment) {
    ref.read(currentTaskProvider.notifier).updateTask(assignment);
    ref.read(tasksProvider.notifier).updateTask(assignment);
  }

  void _updateAssignmentSubject(Tasks assignment) {
    ref.read(currentTaskProvider.notifier).updateTaskSubject(assignment);
    // ref.read(tasksProvider.notifier).updateAssignmentSubject(assignment);
  }

  void _deleteAssignment(Tasks assignment) {
    // ref.read(assignmentsProvider.notifier).deleteAssignment(assignment);
    ref.read(currentTaskProvider.notifier).setCurrentTask(null);
    Navigator.of(context).pop();
  }

  void _subtaskComplete(Subtask subtask) {
    subtask = subtask.copyWith(completed: !subtask.completed);
    ref.read(currentTaskProvider.notifier).updateSubtask(subtask);
    // ref
    //     .read(assignmentsProvider.notifier)
    //     .updateAssignment(ref.read(currentTaskProvider).assignment!);
  }

  void _updateSubtask(Subtask subtask) {
    ref.read(currentTaskProvider.notifier).updateSubtask(subtask);
    // ref
    //     .read(assignmentsProvider.notifier)
    //     .updateAssignment(ref.read(currentTaskProvider).assignment!);
  }

  void _createSubtask(Tasks assignment) async {
    // await ref.read(assignmentsProvider.notifier).createSubtask(assignment);
    // ref.read(currentTaskProvider.notifier).updateCurrentAssignment(assignment);
  }

  bool readOnly = true;

  @override
  Widget build(BuildContext context) {
    void setReadOnly(bool value) {
      SnackbarService.showInfoSnackbar(
          context,
          !value
              ? "Tap a field to edit it"
              : "You are no longer editing the assignment");

      setState(() {
        readOnly = value;
      });
    }

    final currentTaskRef = ref.watch(currentTaskProvider).task;
    final updatedTasks = ref.watch(currentTaskProvider).task;

    final platformBrightness = MediaQuery.of(context).platformBrightness;
    final size = MediaQuery.of(context).size;

    if (currentTaskRef == null) {
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
          child: Text("No assignment selected"),
        ),
      );
    }

    final currentTask = updatedTasks ?? currentTaskRef;
    final categoriesList = ref.watch(categoriesProvider);

    // Local variables to store the current assignment's categories, starred, and completed status
    Set<Categories> categories = categoriesList
        .where((category) => category.id! == currentTask.categoryId)
        .toSet();
    bool isStar = currentTask.starred;
    bool isComp = currentTask.completed;

    // final subtasks = currentTask.subtasks;
    final subtasks = [];

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
                    deleteAssignment: _deleteAssignment,
                    updateAssignment: _updateAssignment,
                    currentTask: currentTask,
                    size: size,
                    isStar: isStar,
                    isComp: isComp,
                    setCurrentAssignmentNull: () {
                      ref
                          .read(currentTaskProvider.notifier)
                          .setCurrentTask(null);
                    },
                    setReadOnly: setReadOnly,
                    readOnly: readOnly,
                  ),

            // Use the enum to create chips
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

            //               final Tasks updatedTasks = currentTask.copyWith(
            //                   categories: categories.toList());

            //               _updateAssignment(updatedTask);
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
                  _updateAssignment(updatedTask);
                },
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.only(left: 8.0),
            //   alignment: Alignment.centerLeft,
            //   child: readOnly == true
            //       ? Text(
            //           currentTask.subject?.name ?? "Select a subject",
            //         )
            //       : SubjectDropdownField(
            //           subjectsList: subjectsList,
            //           onSubjectChanged: (id) {
            //             setState(() {
            //               late Tasks updatedTask;
            //               if (id == '-1' || id == null || id == '') {
            //                 updatedTasks = currentTask.copyWith(subject: null);
            //                 debugPrint("subject: $updatedTask");
            //               } else {
            //                 final subject = subjectsList
            //                     .firstWhere((subject) => subject.$id == id);

            //                 updatedTasks =
            //                     currentTask.copyWith(subject: subject);
            //                 debugPrint("subject: $updatedTask");
            //               }
            //               _updateAssignmentSubject(updatedTask);
            //             });
            //           },
            //           defaultSubjectId: currentTask.subject?.$id,
            //         ),
            // ),

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
                  _updateAssignment(updatedTask);
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
                    _updateAssignment(updatedTask);
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
                itemCount: subtasks.length,
                itemBuilder: (context, index) {
                  final subtask = subtasks[index];
                  return CheckboxListTile(
                    enableFeedback: true,
                    subtitle: subtask?.priority != null
                        ? Text(
                            "Priority: ${subtask?.priority}",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.amber),
                          )
                        : null,
                    value: subtask?.completed,
                    title: TextField(
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
                    updateAssignment: _updateAssignment,
                    deleteAssignment: _deleteAssignment,
                    currentTask: currentTask,
                    setReadOnly: setReadOnly,
                    size: size,
                    isStar: isStar,
                    isComp: isComp,
                    readOnly: readOnly,
                    setCurrentAssignmentNull: () {
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
    required this.updateAssignment,
    required this.currentTask,
    required this.isStar,
    required this.isComp,
    required this.size,
    required this.deleteAssignment,
    required this.setCurrentAssignmentNull,
    required this.setReadOnly,
    required this.readOnly,
  });

  final Tasks? currentTask;
  final void Function(Tasks assignment) updateAssignment;
  final void Function(Tasks assignment) deleteAssignment;
  final void Function(bool readOnly) setReadOnly;
  final Size size;
  final bool isStar, isComp, readOnly;
  final void Function() setCurrentAssignmentNull;

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
            }
            widget.setCurrentAssignmentNull();
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
            widget.updateAssignment(newTask!.copyWith(starred: isStar));
          },
        ),
        IconButton(
          icon: widget.currentTask!.completed
              ? const Icon(Icons.cancel_presentation)
              : const Icon(Icons.check),
          color: widget.currentTask!.completed ? Colors.red : Colors.green,
          onPressed: () {
            isComp = !isComp;
            widget.updateAssignment(newTask!.copyWith(completed: isComp));
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
                              widget.deleteAssignment(widget.currentTask!);

                              isModal ? Navigator.of(context).pop() : null;
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.redAccent),
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
