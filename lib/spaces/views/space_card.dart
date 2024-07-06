import 'package:assigngo_rewrite/categories/models/categories_model.dart';
import 'package:assigngo_rewrite/categories/providers/categories_provider.dart';
import 'package:assigngo_rewrite/spaces/widgets/space_category_tile.dart';
import 'package:assigngo_rewrite/task_list/providers/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assigngo_rewrite/spaces/models/spaces_model.dart';

class SpaceCard extends ConsumerWidget {
  const SpaceCard({super.key, required this.space});

  final Spaces space;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksManagerProvider.select((value) =>
        value.value?.where((task) => task.spaceId == space.id).toList()));

    final currentSpaceCategories = ref.watch(categoriesManagerProvider
        .select((value) => value.value?.where((category) {
              return category.spaceId == space.id;
            }).toList()));
    return Card(
      margin: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              const Color(0xff00BFFF).withOpacity(0.7),
              const Color(0xff00CED1).withOpacity(0.7),
              const Color(0xff2E8B57).withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                titleTextStyle: Theme.of(context).textTheme.titleLarge,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.pen),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.trash),
                    ),
                  ],
                ),
                title: Text(space.title),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: currentSpaceCategories?.length != null
                    ? currentSpaceCategories!.length + 1
                    : 0,
                itemBuilder: (context, index) {
                  final categoryTasksList = tasks!.where((task) {
                    return task.categoryId ==
                        (index < currentSpaceCategories!.length
                            ? currentSpaceCategories[index].id
                            : null);
                  }).toList();
                  if (index < currentSpaceCategories!.length) {
                    final category = currentSpaceCategories[index];
                    return SpaceCategoryTile(
                        category: category, tasks: categoryTasksList);
                  } else {
                    return SpaceCategoryTile(
                      tasks: categoryTasksList,
                      category: Categories(
                        title: "Uncategorized",
                        tasks: tasks,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
