import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/task_list/widgets/sliver_assignments_list.dart';
import 'package:flutter/material.dart';

class StarScreen extends StatelessWidget {
  const StarScreen({super.key, required this.tasks});

  final List<Tasks> tasks;
  static const colors = [
    Colors.purple,
    Colors.orange,
    Colors.amber,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliverTasksList(
        title: "Starred",
        tasks: tasks,
        filter: AssignmentsFilter.starred,
        colors: colors,
      ),
    );
  }
}
