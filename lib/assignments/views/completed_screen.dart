import 'package:assigngo_rewrite/assignments/providers/assignments_provider.dart';
import 'package:assigngo_rewrite/assignments/widgets/assignments_list.dart';
import 'package:assigngo_rewrite/assignments/widgets/sliver_assignments_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompletedScreen extends ConsumerStatefulWidget {
  const CompletedScreen({super.key});

  @override
  ConsumerState<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends ConsumerState<CompletedScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the assignments when the screen is initialized
    ref.read(assignmentsProvider.notifier).fetchAssignments();
  }

  // static const colors = [Colors.purple, Colors.green, Colors.lightGreen];
  static const colors = [
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
  ];

  @override
  Widget build(BuildContext context) {
    final assignments = ref.watch(assignmentsProvider);
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
