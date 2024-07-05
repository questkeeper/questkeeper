import 'package:assigngo_rewrite/categories/models/categories_model.dart';
import 'package:assigngo_rewrite/shared/utils/hex_color.dart';
import 'package:assigngo_rewrite/task_list/models/tasks_model.dart';
import 'package:assigngo_rewrite/task_list/providers/current_task_provider.dart';
import 'package:assigngo_rewrite/task_list/providers/tasks_provider.dart';
import 'package:assigngo_rewrite/shared/utils/format_date.dart';
import 'package:assigngo_rewrite/task_list/task_item/views/assignment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskCard extends ConsumerStatefulWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.category,
    // required this.filter,
  });

  final Tasks task;
  final Categories? category;
  // final TasksFilter filter;

  @override
  ConsumerState<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Tasks task = widget.task;
    return Dismissible(
      key: ValueKey(widget.task.id),
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd) {
          ref.read(tasksManagerProvider.notifier).toggleStar(widget.task);
          return Future.value(false);
          // return widget.filter == TasksFilter.starred
          //     ? Future.value(true)
          //     : Future.value(false);
        } else {
          ref.read(tasksManagerProvider.notifier).toggleComplete(widget.task);
          return Future.value(true);
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
        onTap: () => {
          ref.read(currentTaskProvider.notifier).setCurrentTask(widget.task),
          if (MediaQuery.of(context).size.width < 800)
            {
              // modal for mobile
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
                  return const TaskItemScreen();
                },
              )
            }
        },
        child: SizedBox(
          // height: 150,
          width: double.infinity,
          child: Card(
            color: widget.category != null && widget.category!.color != null
                ? HexColor(widget.category!.color!)
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
                  // if (widget.filter != TasksFilter.completed &&
                  //     task.dueDate.isBefore(DateTime.now().toUtc()))
                  const Chip(
                      label: Text("Overdue",
                          style: TextStyle(color: Colors.black)),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: Colors.redAccent),
                  if (task.dueDate.isAfter(DateTime.now().toUtc()) &&
                      task.dueDate.isBefore(
                          DateTime.now().add(const Duration(days: 1)).toUtc()))
                    const Chip(
                        label: Text("Due Today",
                            style: TextStyle(color: Colors.black)),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.amber),
                  Text(
                    widget.task.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "Due ${formatDate(widget.task.dueDate)}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  // task.subject != null
                  //     ? Text(
                  //         task.subject!.name,
                  //         style: Theme.of(context).textTheme.bodyMedium,
                  //       )
                  //     : const SizedBox.shrink(),
                  const SizedBox(height: 8.0),
                  Text(
                    softWrap: true,
                    widget.task.description ?? "",
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
