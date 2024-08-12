import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/shared/utils/hex_color.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';
import 'package:questkeeper/shared/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/task_list/views/edit_task_bottom_sheet.dart';
import 'package:questkeeper/task_list/task_item/widgets/task_notification_dot.dart';

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
          // FIXME: this will probably break stuff.
          if (MediaQuery.of(context).size.width < 800) {
            showTaskBottomSheet(context: context, ref: ref, existingTask: task);
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
              margin: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      if (task.starred)
                        const Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(
                            LucideIcons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
                      Text(
                        task.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      if (!task.completed &&
                          task.dueDate.isAtSameMomentAs(DateTime.now()
                              .subtract(const Duration(days: 1))
                              .toUtc()))
                        const TaskNotificationDot(
                            notificationType: NotificationDotType.warning),
                      if (!task.completed &&
                          task.dueDate.isBefore(DateTime.now()) &&
                          task.dueDate.isBefore(
                              DateTime.now().subtract(const Duration(days: 1))))
                        const TaskNotificationDot(
                            notificationType: NotificationDotType.danger),
                    ],
                  ),
                  Text(
                    "Due ${formatDate(task.dueDate)}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (task.description != null && task.description!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        softWrap: true,
                        maxLines: 1,
                        task.description ?? "",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
