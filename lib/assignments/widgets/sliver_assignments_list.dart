import 'package:assigngo_rewrite/assignments/assignment/widgets/assignment_card.dart';
import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:flutter/material.dart';

enum AssignmentsFilter { all, starred, completed }

class SliverAssignmentsList extends StatefulWidget {
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

  @override
  State<SliverAssignmentsList> createState() => _SliverAssignmentsListState();
}

class _SliverAssignmentsListState extends State<SliverAssignmentsList> {
  final bool _pinned = true;
  final bool _snap = false;
  final bool _floating = false;
  final value = 0;
  Categories? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    List<Assignment> filteredAssignments = widget.assignments;

    // void updateFilter(Categories? filter) {
    //   if (filter == null) {
    //     _selectedFilter = null;
    //     filteredAssignments = widget.assignments;
    //   } else {
    //     _selectedFilter = filter;
    //     filteredAssignments = widget.assignments
    //         .where((assignment) => assignment.categories!.contains(filter))
    //         .toList();
    //   }
    // }

    double bottom = MediaQuery.of(context).padding.bottom;
    return CustomScrollView(shrinkWrap: true, slivers: [
      SliverAppBar(
        excludeHeaderSemantics: true,
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
                  colors: widget.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          title: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              widget.title,
            ),
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildListDelegate.fixed(
          [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Wrap(
                children: Categories.values
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
                        child: ChoiceChip(
                          label: Text(e.toString().split('.').last),
                          selected: _selectedFilter == e,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = selected ? e : null;
                            });
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.fromLTRB(4.0, 2.0, 4.0, bottom),
        sliver: SliverList.builder(
          itemCount: filteredAssignments.length,
          itemBuilder: (context, index) {
            if (widget.filter == AssignmentsFilter.completed &&
                !filteredAssignments[index].completed) {
              return const SizedBox.shrink();
            }

            if (widget.filter == AssignmentsFilter.starred &&
                (!filteredAssignments[index].starred ||
                    filteredAssignments[index].completed)) {
              return const SizedBox.shrink();
            }

            if (widget.filter == AssignmentsFilter.all &&
                filteredAssignments[index].completed) {
              return const SizedBox.shrink();
            }

            if (_selectedFilter != null &&
                !filteredAssignments[index]
                    .categories!
                    .contains(_selectedFilter)) {
              return const SizedBox.shrink();
            }

            return Container(
              padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
              child: AssignmentCard(
                  assignment: filteredAssignments[index],
                  filter: widget.filter),
            );
          },
        ),
      ),
    ]);
  }
}
