import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/task_list/widgets/sliver_assignments_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.tasks});

  final List<Tasks> tasks;

  static const colors = [
    Colors.purple,
    Colors.blue,
    Colors.lightBlue,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliverTasksList(
        title: "Home",
        tasks: tasks,
        filter: AssignmentsFilter.all,
        colors: colors,
      ),
    );
  }
}
