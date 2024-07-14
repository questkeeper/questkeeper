import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/task_list/widgets/sliver_assignments_list.dart';
import 'package:flutter/material.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key, required this.tasks});

  final List<Tasks> tasks;

  // static const colors = [Colors.purple, Colors.green, Colors.lightGreen];
  static const colors = [
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliverTasksList(
        title: "Completed",
        tasks: tasks,
        filter: AssignmentsFilter.completed,
        colors: colors,
      ),
    );
  }
}
