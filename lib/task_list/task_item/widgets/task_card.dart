import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/layout/utils/state_providers.dart';
import 'package:questkeeper/shared/providers/window_size_provider.dart';
import 'package:questkeeper/shared/utils/hex_color.dart';
import 'package:questkeeper/tabs/new_user_onboarding/providers/onboarding_provider.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';
import 'package:questkeeper/shared/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/task_list/views/edit_task_drawer.dart';
import 'package:questkeeper/task_list/task_item/widgets/task_notification_dot.dart';
// import 'package:rive/rive.dart';

class TaskCard extends ConsumerStatefulWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.category,
  });

  final Tasks task;
  final Categories? category;

  @override
  ConsumerState<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {
  // void _showCompletionAnimation(
  //     BuildContext context, Offset position, Size size) {
  //   OverlayEntry overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       left: position.dx,
  //       top: position.dy,
  //       width: size.width,
  //       height: size.height,
  //       child: Material(
  //         color: Colors.transparent,
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: Colors.green,
  //             borderRadius: BorderRadius.circular(16.0),
  //           ),
  //           child: const RiveAnimation.asset(
  //             'assets/rive/check.riv',
  //             fit: BoxFit.contain,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   Overlay.of(context).insert(overlayEntry);

  //   Future.delayed(const Duration(milliseconds: 1200), () {
  //     overlayEntry.remove();
  //   });
  // }

  void _handleTaskAction(String action) async {
    final isMobile = ref.watch(isMobileProvider);
    final isCompact = ref.watch(isCompactProvider);
    switch (action) {
      case 'complete':
        await ref
            .read(tasksManagerProvider.notifier)
            .toggleComplete(widget.task);
        if (ref.read(onboardingProvider).hasCompletedTask == false &&
            ref.read(onboardingProvider).isOnboardingComplete == false) {
          ref.read(onboardingProvider.notifier).markTaskCompleted();
        }
        break;
      case 'star':
        await ref.read(tasksManagerProvider.notifier).toggleStar(widget.task);
        break;
      case 'edit':
        if (!isMobile && !isCompact) {
          // First set the state to null to trigger cleanup
          ref.read(contextPaneProvider.notifier).state = null;

          // Wait for the next frame to ensure cleanup is complete
          await Future.microtask(() {});

          // Only proceed if still mounted
          if (!mounted) return;

          // Create and set the new context pane
          final contextPane = getTaskDrawerContent(
            context: context,
            ref: ref,
            existingTask: widget.task,
          );
          ref.read(contextPaneProvider.notifier).state = contextPane;
        } else {
          showTaskDrawer(context: context, ref: ref, existingTask: widget.task);
        }
        break;
      case 'delete':
        await ref.read(tasksManagerProvider.notifier).deleteTask(widget.task);
        break;
    }
  }

  void _showContextMenu(BuildContext context, TapDownDetails details) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        details.globalPosition,
        details.globalPosition,
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        PopupMenuItem(
          value: 'complete',
          child: Row(
            children: [
              Icon(
                widget.task.completed
                    ? LucideIcons.circle_x
                    : LucideIcons.check,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(widget.task.completed ? 'Mark Incomplete' : 'Complete'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'star',
          child: Row(
            children: [
              Icon(
                widget.task.starred ? LucideIcons.star_off : LucideIcons.star,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(widget.task.starred ? 'Unstar' : 'Star'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(LucideIcons.pen, size: 18),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(LucideIcons.trash, size: 18),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        _handleTaskAction(value);
      }
    });
  }

  Widget _buildTaskContent(BuildContext context, bool isMobile) {
    final Tasks task = widget.task;

    return Container(
      padding: EdgeInsets.all(
        isMobile ? 8.0 : 12.0,
      ),
      margin: EdgeInsets.all(
        isMobile ? 4.0 : 2.0,
      ),
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
              Expanded(
                child: Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[300],
                      ),
                ),
              ),
              const SizedBox(width: 8.0),
              if (!task.completed &&
                  task.dueDate.isAfter(DateTime.now().toUtc()) &&
                  task.dueDate.difference(DateTime.now().toUtc()).inDays < 1)
                const TaskNotificationDot(
                    notificationType: NotificationDotType.warning),
              if (!task.completed &&
                  task.dueDate.isBefore(DateTime.now().toUtc()))
                const TaskNotificationDot(
                    notificationType: NotificationDotType.danger),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              "Due ${formatDate(task.dueDate)}",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: task.dueDate.isBefore(DateTime.now().toUtc())
                        ? Colors.red
                        : Colors.grey,
                  ),
            ),
          ),
          if (task.description != null &&
              task.description!.isNotEmpty &&
              isMobile)
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(task.description ?? "",
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[400],
                      )),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Tasks task = widget.task;
    final Categories? category = widget.category;
    final isMobile = ref.watch(isMobileProvider);

    return Dismissible(
      key: ValueKey(task.id),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await ref.read(tasksManagerProvider.notifier).toggleStar(widget.task);
          return false;
        } else {
          // final RenderBox renderBox = context.findRenderObject() as RenderBox;
          // final position = renderBox.localToGlobal(Offset.zero);
          // final size = renderBox.size;

          // _showCompletionAnimation(context, position, size);

          await ref
              .read(tasksManagerProvider.notifier)
              .toggleComplete(widget.task);

          if (ref.read(onboardingProvider).hasCompletedTask == false &&
              ref.read(onboardingProvider).isOnboardingComplete == false) {
            ref.read(onboardingProvider.notifier).markTaskCompleted();
          }

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
            Icon(task.starred ? LucideIcons.star : LucideIcons.star_off,
                color: Colors.black),
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
            Icon(
              task.completed ? LucideIcons.circle_x : LucideIcons.check,
              color: Colors.black,
            ),
            Text(
              task.completed ? "Incomplete" : "Complete",
              style: const TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ],
        ),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _handleTaskAction('edit'),
          onSecondaryTapDown: (details) => _showContextMenu(context, details),
          child: Card(
            color: category?.color != null
                ? HexColor(category!.color!).withValues(alpha: 0.1)
                : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2.0,
            child: _buildTaskContent(context, isMobile),
          ),
        ),
      ),
    );
  }
}
