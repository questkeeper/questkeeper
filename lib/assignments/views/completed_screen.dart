import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/widgets/sliver_assignments_list.dart';
import 'package:flutter/material.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key, required this.assignments});

  final List<Assignment> assignments;

  // static const colors = [Colors.purple, Colors.green, Colors.lightGreen];
  static const colors = [
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliverAssignmentsList(
        title: "Completed",
        assignments: assignments,
        filter: AssignmentsFilter.completed,
        colors: colors,
      ),
    );
  }
}
