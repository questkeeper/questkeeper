import 'package:assigngo_rewrite/assignments/providers/assignments_provider.dart';
import 'package:assigngo_rewrite/assignments/widgets/assignments_list.dart';
import 'package:assigngo_rewrite/assignments/widgets/sliver_assignments_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the assignments when the screen is initialized
    ref.read(assignmentsProvider.notifier).fetchAssignments();
  }

  static const colors = [
    Colors.deepPurple,
    Colors.purple,
    Colors.indigo,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    final assignments = ref.watch(assignmentsProvider);

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
