import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/widgets/assignments_list.dart';
import 'package:flutter/material.dart';

class SliverAssignmentsList extends StatelessWidget {
  const SliverAssignmentsList(
      {super.key,
      required this.assignments,
      required this.filter,
      required this.colors,
      required this.title});

  final List<Assignment> assignments;
  final AssignmentsFilter filter;
  final List<Color> colors;
  final String title;

  final bool _pinned = true;
  final bool _snap = false;
  final bool _floating = false;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(shrinkWrap: true, slivers: [
      SliverAppBar(
        pinned: _pinned,
        snap: _snap,
        floating: _floating,
        expandedHeight: 150.0,
        backgroundColor: Colors.deepPurple,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: Opacity(
            opacity: 0.5,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          title: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              title,
            ),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.all(8.0),
        sliver: AssignmentsList(assignments: assignments, filter: filter),
      ),
    ]);
  }
}
