import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/providers/current_assignment_provider.dart';
import 'package:assigngo_rewrite/assignments/providers/assignments_provider.dart';
import 'package:assigngo_rewrite/assignments/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:assigngo_rewrite/assignments/widgets/date_time_picker.dart';
import 'package:assigngo_rewrite/assignments/widgets/subject_dropdown_field.dart';
import 'package:assigngo_rewrite/shared/utils/format_date.dart';
import 'package:assigngo_rewrite/shared/widgets/snackbar.dart';
import 'package:assigngo_rewrite/subjects/providers/subjects_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssignmentScreen extends ConsumerStatefulWidget {
  const AssignmentScreen({super.key});

  @override
  ConsumerState<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends ConsumerState<AssignmentScreen> {
  void _updateAssignment(Assignment assignment) {
    ref.read(currentAssignmentProvider.notifier).updateAssignment(assignment);
    ref.read(assignmentsProvider.notifier).updateAssignment(assignment);
  }

  void _updateAssignmentSubject(Assignment assignment) {
    ref
        .read(currentAssignmentProvider.notifier)
        .updateAssignmentSubject(assignment);
    ref.read(assignmentsProvider.notifier).updateAssignmentSubject(assignment);
  }

  void _deleteAssignment(Assignment assignment) {
    ref.read(assignmentsProvider.notifier).deleteAssignment(assignment);
    ref.read(currentAssignmentProvider.notifier).setCurrentAssignment(null);
    Navigator.of(context).pop();
  }

  void _subtaskComplete(Subtask subtask) {
    subtask = subtask.copyWith(completed: !subtask.completed);
    ref.read(currentAssignmentProvider.notifier).updateSubtask(subtask);
    ref
        .read(assignmentsProvider.notifier)
        .updateAssignment(ref.read(currentAssignmentProvider).assignment!);
  }

  void _updateSubtask(Subtask subtask) {
    ref.read(currentAssignmentProvider.notifier).updateSubtask(subtask);
    ref
        .read(assignmentsProvider.notifier)
        .updateAssignment(ref.read(currentAssignmentProvider).assignment!);
  }

  void _createSubtask(Assignment assignment) async {
    await ref.read(assignmentsProvider.notifier).createSubtask(assignment);
    ref
        .read(currentAssignmentProvider.notifier)
        .updateCurrentAssignment(assignment);
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

    final currentAssignmentRef =
        ref.watch(currentAssignmentProvider).assignment;
    final updatedAssignment = ref.watch(currentAssignmentProvider).assignment;

    final platformBrightness = MediaQuery.of(context).platformBrightness;
    final size = MediaQuery.of(context).size;

    if (currentAssignmentRef == null) {
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

    final currentAssignment = updatedAssignment ?? currentAssignmentRef;
    final subjectsList = ref.watch(subjectsProvider);

    // Local variables to store the current assignment's categories, starred, and completed status
    Set<Categories> categories = currentAssignment.categories.toSet();
    bool isStar = currentAssignment.starred;
    bool isComp = currentAssignment.completed;

    final subtasks = currentAssignment.subtasks;

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
                    currentAssignment: currentAssignment,
                    size: size,
                    isStar: isStar,
                    isComp: isComp,
                    setCurrentAssignmentNull: () {
                      ref
                          .read(currentAssignmentProvider.notifier)
                          .setCurrentAssignment(null);
                    },
                    setReadOnly: setReadOnly,
                    readOnly: readOnly,
                  ),

            // Use the enum to create chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Wrap(
                spacing: 8.0,
                children: Categories.values
                    .map((category) => FilterChip(
                        selected: categories.contains(category),
                        selectedColor: const Color(0xFFa86fd1),
                        showCheckmark: false,
                        deleteIcon: const Icon(Icons.close),
                        label: Text(
                          category.toString().split('.').last,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        onSelected: (bool value) {
                          if (value) {
                            categories.add(category);
                          } else {
                            categories.remove(category);
                          }

                          final Assignment updatedAssignment = currentAssignment
                              .copyWith(categories: categories.toList());

                          _updateAssignment(updatedAssignment);
                        }))
                    .toList(),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
              alignment: Alignment.centerLeft,
              child: TextField(
                readOnly: readOnly,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: currentAssignment.title,
                  hintStyle: Theme.of(context).textTheme.headlineLarge,
                ),
                style: Theme.of(context).textTheme.headlineLarge,
                onSubmitted: (String value) {
                  final Assignment updatedAssignment =
                      currentAssignment.copyWith(title: value);
                  _updateAssignment(updatedAssignment);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 8.0),
              alignment: Alignment.centerLeft,
              child: readOnly == true
                  ? Text(
                      currentAssignment.subject?.name ?? "Select a subject",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    )
                  : SubjectDropdownField(
                      subjectsList: subjectsList,
                      onSubjectChanged: (id) {
                        setState(() {
                          late Assignment updatedAssignment;
                          if (id == '-1' || id == null || id == '') {
                            updatedAssignment =
                                currentAssignment.copyWith(subject: null);
                            debugPrint("subject: $updatedAssignment");
                          } else {
                            final subject = subjectsList
                                .firstWhere((subject) => subject.$id == id);

                            updatedAssignment =
                                currentAssignment.copyWith(subject: subject);
                            debugPrint("subject: $updatedAssignment");
                          }
                          _updateAssignmentSubject(updatedAssignment);
                        });
                      },
                      defaultSubjectId: currentAssignment.subject?.$id,
                    ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 8.0),
              alignment: Alignment.centerLeft,
              child: TextField(
                readOnly: readOnly,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: currentAssignment.description != null &&
                          currentAssignment.description!.isNotEmpty
                      ? currentAssignment.description
                      : "Description here..",
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                onSubmitted: (String value) {
                  final Assignment updatedAssignment =
                      currentAssignment.copyWith(description: value);
                  _updateAssignment(updatedAssignment);
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
                  currentAssignment.dueDate,
                  (DateTime selectedDateTime) {
                    final Assignment updatedAssignment =
                        currentAssignment.copyWith(dueDate: selectedDateTime);
                    _updateAssignment(updatedAssignment);
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Due ${formatDate(currentAssignment.dueDate)}",
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
                      _createSubtask(currentAssignment);
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
                    currentAssignment: currentAssignment,
                    setReadOnly: setReadOnly,
                    size: size,
                    isStar: isStar,
                    isComp: isComp,
                    readOnly: readOnly,
                    setCurrentAssignmentNull: () {
                      ref
                          .read(currentAssignmentProvider.notifier)
                          .setCurrentAssignment(null);
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
    required this.currentAssignment,
    required this.isStar,
    required this.isComp,
    required this.size,
    required this.deleteAssignment,
    required this.setCurrentAssignmentNull,
    required this.setReadOnly,
    required this.readOnly,
  });

  final Assignment? currentAssignment;
  final void Function(Assignment assignment) updateAssignment;
  final void Function(Assignment assignment) deleteAssignment;
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
    var newAssignment = widget.currentAssignment;

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
            widget.updateAssignment(newAssignment!.copyWith(starred: isStar));
          },
        ),
        IconButton(
          icon: widget.currentAssignment!.completed
              ? const Icon(Icons.cancel_presentation)
              : const Icon(Icons.check),
          color:
              widget.currentAssignment!.completed ? Colors.red : Colors.green,
          onPressed: () {
            isComp = !isComp;
            widget.updateAssignment(newAssignment!.copyWith(completed: isComp));
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
                        "Are you sure you want to delete ${widget.currentAssignment!.title}?",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel")),
                        ElevatedButton(
                            onPressed: () {
                              widget
                                  .deleteAssignment(widget.currentAssignment!);

                              isModal ? Navigator.of(context).pop() : null;
                            },
                            child: const Text("Delete")),
                      ],
                    ));
          },
        ),
      ],
    );
  }
}
