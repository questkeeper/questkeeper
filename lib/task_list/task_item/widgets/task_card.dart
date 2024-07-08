import 'package:assigngo_rewrite/categories/models/categories_model.dart';
import 'package:assigngo_rewrite/shared/utils/hex_color.dart';
import 'package:assigngo_rewrite/task_list/models/tasks_model.dart';
import 'package:assigngo_rewrite/task_list/providers/current_task_provider.dart';
import 'package:assigngo_rewrite/task_list/providers/tasks_provider.dart';
import 'package:assigngo_rewrite/shared/utils/format_date.dart';
import 'package:assigngo_rewrite/task_list/task_item/views/assignment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskCard extends ConsumerWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.category,
  });

  final Tasks task;
  final Categories? category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(task.id),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await ref.read(tasksManagerProvider.notifier).toggleStar(task);
          return false;
        } else {
          await ref.read(tasksManagerProvider.notifier).toggleComplete(task);
          return true;
        }
      },
      background: Container(
        color: Colors.amber,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(task.starred ? Icons.star : Icons.star_outline,
                color: Colors.black, size: 32.0),
            const Text(
              "Star",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: task.completed ? Colors.red : Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(task.completed ? Icons.cancel_presentation : Icons.check,
                color: Colors.black, size: 32.0),
            Text(
              task.completed ? "Incomplete" : "Complete",
              style: const TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ],
        ),
      ),
      child: InkWell(
        radius: 16.0,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        splashColor: Colors.transparent,
        enableFeedback: true,
        onTap: () {
          if (MediaQuery.of(context).size.width < 800) {
            showModalBottomSheet(
              enableDrag: true,
              isScrollControlled: true,
              useSafeArea: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              showDragHandle: true,
              context: context,
              builder: (context) {
                ref.read(currentTaskProvider.notifier).setCurrentTask(task);
                return const TaskItemScreen();
              },
            );
          }
        },
        child: SizedBox(
          width: double.infinity,
          child: Card(
            color: category != null && category!.color != null
                ? HexColor(category!.color!)
                : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 2.0,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (task.dueDate.isBefore(DateTime.now().toUtc()))
                    const Chip(
                      label: Text("Overdue",
                          style: TextStyle(color: Colors.black)),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: Colors.redAccent,
                    ),
                  if (task.dueDate.isAfter(DateTime.now().toUtc()) &&
                      task.dueDate.isBefore(
                          DateTime.now().add(const Duration(days: 1)).toUtc()))
                    const Chip(
                      label: Text("Due Today",
                          style: TextStyle(color: Colors.black)),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: Colors.amber,
                    ),
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "Due ${formatDate(task.dueDate)}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    softWrap: true,
                    task.description ?? "",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
