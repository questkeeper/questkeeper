import 'package:assigngo_rewrite/assignments/assignment/ui/assignment_card.dart';
import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:flutter/material.dart';

enum AssignmentsFilter { all, starred, completed }

class AssignmentsList extends StatelessWidget {
  const AssignmentsList(
      {super.key, required this.assignments, required this.filter});

  final List<Assignment> assignments;
  final AssignmentsFilter filter;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (filter == AssignmentsFilter.completed &&
              !assignments[index].completed) {
            return const SizedBox.shrink();
          }

          if (filter == AssignmentsFilter.starred &&
              (!assignments[index].starred || assignments[index].completed)) {
            return const SizedBox.shrink();
          }

          if (filter == AssignmentsFilter.all && assignments[index].completed) {
            return const SizedBox.shrink();
          }

          return Container(
            padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
            child:
                AssignmentCard(assignment: assignments[index], filter: filter),
          );
        },
        childCount: assignments.length,
      ),
    );
  }
}
