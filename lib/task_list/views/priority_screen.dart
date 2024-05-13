import 'package:assigngo_rewrite/task_list/models/assignments_model.dart';
import 'package:assigngo_rewrite/task_list/widgets/sliver_assignments_list.dart';
import 'package:flutter/material.dart';

class StarScreen extends StatelessWidget {
  const StarScreen({super.key, required this.assignments});

  final List<Assignment> assignments;
  static const colors = [
    Colors.purple,
    Colors.orange,
    Colors.amber,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliverAssignmentsList(
        title: "Starred",
        assignments: assignments,
        filter: AssignmentsFilter.starred,
        colors: colors,
      ),
    );
  }
}
