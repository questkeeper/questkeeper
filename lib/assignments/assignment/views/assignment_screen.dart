import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/providers/current_assignment_provider.dart';
import 'package:assigngo_rewrite/assignments/providers/assignments_provider.dart';
import 'package:assigngo_rewrite/assignments/subtasks/providers/subtasks_providers.dart';
import 'package:assigngo_rewrite/assignments/subtasks/repositories/subtasks_repository.dart';
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
  @override
  Widget build(BuildContext context) {
    final assignments = ref.watch(assignmentsProvider);
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

    final currentAssignment = assignments.firstWhere(
        (a) => a.id == ref.watch(currentAssignmentProvider).assignment?.id);

    ref
        .read(subtasksProvider.notifier)
        .getAssignmentSubtasks(currentAssignment.id!);
    final subtasks = ref.watch(subtasksProvider).subtasks;

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
                    ref: ref, currentAssignment: currentAssignment, size: size),
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
              itemCount: subtasks.length,
              itemBuilder: (context, index) {
                final subtask = subtasks[index];
                return CheckboxListTile(
                  subtitle: subtask.priority != null
                      ? Text(
                          "Priority: ${subtask.priority}",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.amber),
                        )
                      : null,
                  value: subtask.completed,
                  title: Text(
                    subtask.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onChanged: (bool? value) {
                    SubtasksRepository().toggleComplete(subtask);
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
                    ref: ref, currentAssignment: currentAssignment, size: size),
            SizedBox(height: MediaQuery.of(context).padding.top + 10),
          ],
        ),
      ),
    );
  }
}

class ActionButtons extends ConsumerStatefulWidget {
  const ActionButtons({
    super.key,
    required this.ref,
    required this.currentAssignment,
    required this.size,
  });

  final WidgetRef ref;
  final Assignment? currentAssignment;
  final Size size;

  @override
  ConsumerState<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends ConsumerState<ActionButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      // space evenly to take up the full width
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Pop the screen when the back button is tapped
            widget.size.width > 800 ? null : Navigator.of(context).pop();
            widget.ref
                .read(currentAssignmentProvider.notifier)
                .setCurrentAssignment(null);
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
            widget.ref.read(currentAssignmentProvider.notifier);

            widget.ref
                .read(currentAssignmentProvider.notifier)
                .setCurrentAssignment(widget.currentAssignment);
          },
        ),
        IconButton(
          icon: widget.currentAssignment!.starred
              ? const Icon(Icons.star)
              : const Icon(Icons.star_outline),
          color: Colors.amber,
          onPressed: () {
            widget.ref.read(assignmentsProvider.notifier).toggleStar(
                  widget.currentAssignment!,
                );
          },
        ),
        IconButton(
          icon: widget.currentAssignment!.completed
              ? const Icon(Icons.cancel_presentation)
              : const Icon(Icons.check),
          color:
              widget.currentAssignment!.completed ? Colors.red : Colors.green,
          onPressed: () {
            widget.ref.read(assignmentsProvider.notifier).toggleComplete(
                  widget.currentAssignment!,
                );
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
                              widget.ref
                                  .read(assignmentsProvider.notifier)
                                  .deleteAssignment(widget.currentAssignment!);
                              Navigator.of(context).pop();
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
