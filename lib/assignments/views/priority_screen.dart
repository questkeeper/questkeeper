import 'package:assigngo_rewrite/assignments/widgets/assignments_list.dart';
import 'package:assigngo_rewrite/assignments/widgets/sliver_assignments_list.dart';
import 'package:flutter/material.dart';

class StarScreen extends StatelessWidget {
  const StarScreen({super.key, required this.assignments});

  final List<Map<String, dynamic>> assignments;
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
