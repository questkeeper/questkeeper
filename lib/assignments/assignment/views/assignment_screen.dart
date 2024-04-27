import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/providers/current_assignment_provider.dart';
import 'package:assigngo_rewrite/assignments/providers/assignments_provider.dart';
import 'package:assigngo_rewrite/assignments/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:assigngo_rewrite/assignments/subtasks/providers/subtasks_providers.dart';
import 'package:assigngo_rewrite/shared/utils/format_date.dart';
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

  void _deleteAssignment(Assignment assignment) {
    ref.read(assignmentsProvider.notifier).deleteAssignment(assignment);
    ref.read(currentAssignmentProvider.notifier).setCurrentAssignment(null);
    Navigator.of(context).pop();
  }

  void _subtaskComplete(Subtask subtask) {
    subtask = subtask.copyWith(completed: !subtask.completed);
    ref.read(currentAssignmentProvider.notifier).updateSubtask(subtask);
    ref.read(subtasksProvider.notifier).toggleSubtaskDone(subtask);
  }

  @override
  Widget build(BuildContext context) {
    final currentAssignmentRef =
        ref.watch(currentAssignmentProvider).assignment;

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

    final currentAssignment = currentAssignmentRef;

    // Local variables to store the current assignment's categories, starred, and completed status
    Set<Categories> categories = currentAssignment.categories.toSet();
    bool isStar = currentAssignment.starred;
    bool isComp = currentAssignment.completed;

    final subtasks = currentAssignment.subtasks;

    return Scaffold(
      body: Container(
        padding: size.width > 800
            ? const EdgeInsets.all(32.0)
            : const EdgeInsets.all(8),
        margin: size.width > 800
            ? const EdgeInsets.all(32.0)
            : const EdgeInsets.all(8),
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
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                  style: Theme.of(context).textTheme.headlineLarge,
                  currentAssignment.title),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                currentAssignment.description ?? "",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                "Due ${formatDate(currentAssignment.dueDate)}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                "Subtasks",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: subtasks?.length ?? 0,
              itemBuilder: (context, index) {
                final subtask = subtasks?[index];
                return CheckboxListTile(
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
                  title: Text(
                    subtask!.title,
                    style: Theme.of(context).textTheme.bodyMedium,
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
                    size: size,
                    isStar: isStar,
                    isComp: isComp,
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
  });

  final Assignment? currentAssignment;
  final void Function(Assignment assignment) updateAssignment;
  final void Function(Assignment assignment) deleteAssignment;
  final Size size;
  final bool isStar, isComp;
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
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Navigate to the edit screen
            Navigator.of(context).pushNamed(
                '/edit-assignment?assignmentId=${widget.currentAssignment!.$id}');
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
