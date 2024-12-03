import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';

class ActionButtons extends ConsumerWidget {
  const ActionButtons({
    super.key,
    required this.currentTask,
    required this.size,
    required this.deleteTask,
    required this.toggleStarTask,
    required this.toggleCompleteTask,
  });

  final Tasks currentTask;
  final void Function(Tasks assignment) deleteTask;
  final void Function(Tasks assignment) toggleStarTask;
  final void Function(Tasks assignment) toggleCompleteTask;
  final Size size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the task state from the provider
    final taskState = ref.watch(tasksManagerProvider);

    // Find the current task in the provider's state
    final updatedTask = taskState.value?.firstWhere(
      (task) => task.id == currentTask.id,
      orElse: () => currentTask,
    );

    final isModal = ModalRoute.of(context) is PopupRoute;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        updatedTask == null
            ? const SizedBox()
            : IconButton(
                icon: const Icon(LucideIcons.chevron_left),
                onPressed: () {
                  if (isModal) {
                    Navigator.of(context).pop();
                  }
                },
              ),
        Visibility(
          maintainSize: false,
          visible: size.width > 800,
          child: const Spacer(),
        ),
        IconButton(
          icon: updatedTask!.starred
              ? const Icon(LucideIcons.star_off)
              : const Icon(LucideIcons.star),
          color: Colors.amber,
          onPressed: () => toggleStarTask(updatedTask),
        ),
        IconButton(
          icon: updatedTask.completed
              ? const Icon(LucideIcons.square_x)
              : const Icon(LucideIcons.check),
          color: updatedTask.completed ? Colors.red : Colors.green,
          onPressed: () => toggleCompleteTask(updatedTask),
        ),
        IconButton(
          icon: const Icon(LucideIcons.trash),
          color: Colors.red,
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      content: Text(
                        "Are you sure you want to delete ${updatedTask.title}?",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel")),
                        FilledButton(
                            onPressed: () {
                              deleteTask(updatedTask);

                              isModal ? Navigator.of(context).pop() : null;
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
