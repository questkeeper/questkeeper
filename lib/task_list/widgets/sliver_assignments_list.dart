import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/task_list/task_item/widgets/task_card.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AssignmentsFilter { all, starred, completed }

class SliverTasksList extends ConsumerStatefulWidget {
  const SliverTasksList(
      {super.key,
      required this.tasks,
      required this.filter,
      required this.colors,
      required this.title});

  final List<Tasks> tasks;

  final AssignmentsFilter filter;
  final List<Color> colors;
  final String title;

  @override
  ConsumerState<SliverTasksList> createState() => _SliverTasksListState();
}

class _SliverTasksListState extends ConsumerState<SliverTasksList> {
  final bool _pinned = true;
  final bool _snap = false;
  final bool _floating = false;
  final value = 0;
  // Filters? _selectedFilter;

  @override
  void initState() {
    super.initState();
    ref.read(categoriesManagerProvider.notifier).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    List<Tasks> filteredTasks = widget.tasks;
    final categories = ref.watch(categoriesManagerProvider);

    double bottom = MediaQuery.of(context).padding.bottom;
    return CustomScrollView(slivers: [
      SliverAppBar.medium(
        excludeHeaderSemantics: true,
        pinned: _pinned,
        snap: _snap,
        floating: _floating,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(widget.title),
          centerTitle: false,
          titlePadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
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
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      // SliverList(
      //   delegate: SliverChildListDelegate.fixed(
      //     [
      //       SingleChildScrollView(
      //         scrollDirection: Axis.horizontal,
      //         physics: const ClampingScrollPhysics(),
      //         child: Wrap(
      //           children: Filters.values
      //               .map(
      //                 (e) => Padding(
      //                   padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
      //                   child: ChoiceChip(
      //                     label: Text(e.toString().split('.').last),
      //                     selected: _selectedFilter == e,
      //                     onSelected: (selected) {
      //                       setState(() {
      //                         _selectedFilter = selected ? e : null;
      //                       });
      //                     },
      //                   ),
      //                 ),
      //               )
      //               .toList(),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
      SliverPadding(
        padding: EdgeInsets.fromLTRB(4.0, 2.0, 4.0, bottom),
        sliver: SliverList.builder(
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            if (widget.filter == AssignmentsFilter.completed &&
                !filteredTasks[index].completed) {
              return const SizedBox.shrink();
            }

            if (widget.filter == AssignmentsFilter.starred &&
                (!filteredTasks[index].starred ||
                    filteredTasks[index].completed)) {
              return const SizedBox.shrink();
            }

            if (widget.filter == AssignmentsFilter.all &&
                filteredTasks[index].completed) {
              return const SizedBox.shrink();
            }

            // if (_selectedFilter != null &&
            //     !filteredTasks[index].categories.contains(_selectedFilter)) {
            //   return const SizedBox.shrink();
            // }

            Categories? category;

            if (filteredTasks[index].categoryId != null) {
              category = categories.asData!.value.firstWhere(
                  (element) => element.id == filteredTasks[index].categoryId);
            }

            return Container(
              padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
              child: TaskCard(
                task: filteredTasks[index],
                category: category,
              ),
            );
          },
        ),
      ),
    ]);
  }
}
