import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/categories/views/edit_space_bottom_sheet.dart';
import 'package:questkeeper/shared/extensions/color_extensions.dart';
import 'package:questkeeper/shared/extensions/string_extensions.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/spaces/views/edit_space_bottom_sheet.dart';
import 'package:questkeeper/spaces/widgets/delete_space_dialog.dart';
import 'package:questkeeper/spaces/widgets/space_category_tile.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';

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

    final baseColor =
        space.color != null ? space.color!.toColor() : const Color(0xff00CED1);
    return Card(
      margin: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: baseColor.toCardGradientColor(),
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: ListTile(
                titleTextStyle: Theme.of(context).textTheme.headlineMedium,
                trailing: SpaceActionWidgets(space: space, ref: ref),
                title: Text(space.title),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: currentSpaceCategories?.length != null
                    ? currentSpaceCategories!.length + 1
                    : 0,
                itemBuilder: (context, index) {
                  final categoryTasksList = tasks?.where((task) {
                    return task.categoryId ==
                        (index < currentSpaceCategories!.length
                            ? currentSpaceCategories[index].id
                            : null);
                  }).toList();
                  if (index < currentSpaceCategories!.length) {
                    final category = currentSpaceCategories[index];
                    return SpaceCategoryTile(
                        ref: ref, category: category, tasks: categoryTasksList);
                  } else {
                    return SpaceCategoryTile(
                      ref: ref,
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

class SpaceActionWidgets extends StatelessWidget {
  const SpaceActionWidgets({
    super.key,
    required this.space,
    required this.ref,
  });

  final Spaces space;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SpaceAction>(
      icon: const Icon(LucideIcons.menu),
      iconSize: 32,
      onSelected: (action) {
        switch (action) {
          case SpaceAction.newCategory:
            showCategoryBottomSheet(
                context: context, ref: ref, existingSpace: space);
            break;
          case SpaceAction.edit:
            showSpaceBottomSheet(
                context: context, ref: ref, existingSpace: space);
            break;
          case SpaceAction.delete:
            showDialog(
              context: context,
              builder: (context) => DeleteSpaceDialog(
                space: space,
                deleteSpace: () {
                  ref.read(spacesManagerProvider.notifier).deleteSpace(space);
                  SnackbarService.showInfoSnackbar(
                      context, "Space deleted successfully");
                },
              ),
            );
            break;
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tooltip: 'Actions for your current space',
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: SpaceAction.newCategory,
          child: Row(
            children: [
              Icon(LucideIcons.folder_plus),
              SizedBox(width: 8),
              Text('New Category'),
            ],
          ),
        ),
        if (space.id != null) ...menuItemsSpaceNotNull,
      ],
    );
  }
}

const menuItemsSpaceNotNull = [
  PopupMenuItem(
    value: SpaceAction.edit,
    child: Row(
      children: [
        Icon(LucideIcons.pen),
        SizedBox(width: 8),
        Text('Edit'),
      ],
    ),
  ),
  PopupMenuItem(
    value: SpaceAction.delete,
    child: Row(
      children: [
        Icon(LucideIcons.trash),
        SizedBox(width: 8),
        Text('Delete'),
      ],
    ),
  ),
];

enum SpaceAction { edit, delete, newCategory }
