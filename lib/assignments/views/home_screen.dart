import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/widgets/sliver_assignments_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.assignments});

  final List<Assignment> assignments;

  static const colors = [
    Colors.purple,
    Colors.blue,
    Colors.lightBlue,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliverAssignmentsList(
        title: "Assignments",
        assignments: assignments,
        filter: AssignmentsFilter.all,
        colors: colors,
      ),
    );
  }
}
