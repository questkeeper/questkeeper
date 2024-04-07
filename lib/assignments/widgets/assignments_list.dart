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
          if (filter == AssignmentsFilter.starred &&
              !assignments[index].starred) {
            return const SizedBox.shrink();
          }

          if (filter == AssignmentsFilter.completed &&
              !assignments[index].completed) {
            return const SizedBox.shrink();
          }

          return Card(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignments[index].title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    assignments[index].description,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: assignments.length,
      ),
    );
  }
}
