import 'package:assigngo_rewrite/assignments/providers/assignments_provider.dart';
import 'package:assigngo_rewrite/assignments/widgets/assignments_list.dart';
import 'package:assigngo_rewrite/assignments/widgets/sliver_assignments_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StarScreen extends ConsumerStatefulWidget {
  const StarScreen({super.key});

  @override
  ConsumerState<StarScreen> createState() => _StarScreenState();
}

class _StarScreenState extends ConsumerState<StarScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the assignments when the screen is initialized
    ref.read(assignmentsProvider.notifier).fetchAssignments();
  }

  static const colors = [
    Colors.purple,
    Colors.orange,
    Colors.amber,
  ];
  @override
  Widget build(BuildContext context) {
    final assignments = ref.watch(assignmentsProvider);
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
