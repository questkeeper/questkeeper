import 'package:assigngo_rewrite/assignments/assignment/views/assignment_screen.dart';
import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/providers/assignment_provider.dart';
import 'package:assigngo_rewrite/assignments/providers/assignments_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssignmentCard extends ConsumerStatefulWidget {
  const AssignmentCard({
    super.key,
    required this.assignment,
  });

  final Assignment assignment;

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
          ref
              .read(assignmentsProvider.notifier)
              .starAssignment(widget.assignment.id!);
          return Future.value(true);
        } else {
          ref
              .read(assignmentsProvider.notifier)
              .completeAssignment(widget.assignment.id!);
          return Future.value(false);
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
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
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
          height: 120.0,
          width: double.infinity,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 2.0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.assignment.title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.assignment.description ?? "",
                    style: const TextStyle(fontSize: 16.0),
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
