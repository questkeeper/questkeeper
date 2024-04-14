import 'package:assigngo_rewrite/assignments/assignment/views/assignment_screen.dart';
import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/providers/current_assignment_provider.dart';
import 'package:assigngo_rewrite/assignments/providers/assignments_provider.dart';
import 'package:assigngo_rewrite/assignments/widgets/sliver_assignments_list.dart';
import 'package:assigngo_rewrite/shared/utils/format_date.dart';
import 'package:assigngo_rewrite/shared/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssignmentCard extends ConsumerStatefulWidget {
  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.filter,
  });

  final Assignment assignment;
  final AssignmentsFilter filter;

  @override
  ConsumerState<AssignmentCard> createState() => _AssignmentCardState();
}

class _AssignmentCardState extends ConsumerState<AssignmentCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Assignment assignment = widget.assignment;
    return Dismissible(
      key: ValueKey(widget.assignment.id),
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd) {
          ref.read(assignmentsProvider.notifier).toggleStar(widget.assignment);
          return widget.filter == AssignmentsFilter.starred
              ? Future.value(true)
              : Future.value(false);
        } else {
          ref
              .read(assignmentsProvider.notifier)
              .toggleComplete(widget.assignment);
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
            Icon(assignment.starred ? Icons.star : Icons.star_outline,
                color: Colors.black, size: 32.0),
            const Text(
              "Star",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: assignment.completed ? Colors.red : Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(assignment.completed ? Icons.cancel_presentation : Icons.check,
                color: Colors.black, size: 32.0),
            Text(
              assignment.completed ? "Incomplete" : "Complete",
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
          ref
              .read(currentAssignmentProvider.notifier)
              .setCurrentAssignment(widget.assignment),
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
                  return const AssignmentScreen();
                },
              )
            }
        },
        child: SizedBox(
          // height: 150,
          width: double.infinity,
          child: Card(
            color: assignment.subjectId != null &&
                    assignment.subject != null &&
                    assignment.subject?.color != null
                ? HexColor(assignment.subject!.color!)
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
                  Text(
                    widget.assignment.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "Due ${formatDate(widget.assignment.dueDate)}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  assignment.subject != null
                      ? Text(
                          assignment.subject!.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 8.0),
                  Text(
                    softWrap: true,
                    widget.assignment.description ?? "",
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
