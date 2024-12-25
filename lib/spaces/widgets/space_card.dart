import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/categories/views/edit_category_bottom_sheet.dart';
import 'package:questkeeper/shared/extensions/datetime_extensions.dart';
import 'package:questkeeper/shared/extensions/string_extensions.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/spaces/providers/game_height_provider.dart';
import 'package:questkeeper/spaces/providers/game_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/spaces/views/edit_space_bottom_sheet.dart';
import 'package:questkeeper/spaces/widgets/delete_space_dialog.dart';
import 'package:questkeeper/spaces/widgets/space_category_tile.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';

class SpaceCard extends ConsumerStatefulWidget {
  const SpaceCard(
      {super.key, required this.space, required this.backgroundColorHex});

  final Spaces space;
  final String backgroundColorHex;

  @override
  ConsumerState<SpaceCard> createState() => _SpaceCardState();
}

class _SpaceCardState extends ConsumerState<SpaceCard> {
  final ScrollController _scrollController = ScrollController();
  bool _isMinimized = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset <= 0 && _isMinimized) {
      if (_scrollController.position.maxScrollExtent <= 0) {
        ref.read(gameHeightProvider.notifier).state = 1.0;
        if (_isMinimized) setState(() => _isMinimized = false);

        return;
      }
      ref.read(gameHeightProvider.notifier).state = 1.0;
      setState(() => _isMinimized = false);
    }
    // Check if we're scrolling down
    else if (_scrollController.offset > 0 && !_isMinimized) {
      ref.read(gameHeightProvider.notifier).state =
          0.3; // Minimized height factor
      setState(() => _isMinimized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final space = widget.space;
    final tasks = ref.watch(tasksManagerProvider.select((value) =>
        value.value?.where((task) => task.spaceId == space.id).toList()));
    final gameHeight = ref.watch(gameHeightProvider);

    final currentSpaceCategories = ref.watch(categoriesManagerProvider
        .select((value) => value.value?.where((category) {
              return category.spaceId == space.id;
            }).toList()));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          color: widget.backgroundColorHex.toColor(),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: ListTile(
                titleTextStyle: Theme.of(context).textTheme.headlineMedium,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      icon: gameHeight > 0.3
                          ? const Icon(LucideIcons.minimize_2)
                          : const Icon(LucideIcons.maximize_2),
                      onPressed: () {
                        ref.read(gameHeightProvider.notifier).state =
                            gameHeight > 0.3 ? 0.3 : 1.0;
                      },
                    ),
                    SpaceActionWidgets(space: space, ref: ref),
                  ],
                ),
                title: Text(space.title),
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
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
                        category: category,
                        tasks: categoryTasksList,
                      );
                    } else {
                      // Check if there are tasks without a category
                      if (tasks?.any((task) => task.categoryId == null) ==
                          true) {
                        return SpaceCategoryTile(
                          tasks: categoryTasksList,
                          category: Categories(
                            title: "Uncategorized",
                            tasks: tasks,
                          ),
                        );
                      }

                      if (currentSpaceCategories.isEmpty == true) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 16),
                            Center(
                              child: FilledButton(
                                onPressed: () => showCategoryBottomSheet(
                                    context: context,
                                    ref: ref,
                                    existingSpace: space),
                                child: Text('Create a category'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                textAlign: TextAlign.center,
                                'Or create a task and an "uncategorized" category will be created automatically',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color
                                          ?.withOpacity(0.75),
                                    ),
                              ),
                            ),
                          ],
                        );
                      }

                      return Container();
                    }
                  },
                ),
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
    final game = ref.read(gameProvider);
    return PopupMenuButton<SpaceAction>(
      icon: const Icon(LucideIcons.menu),
      iconColor: Theme.of(context).textTheme.bodyLarge?.color,
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
                deleteSpace: () async {
                  final spaces = await ref
                      .watch(spacesManagerProvider.notifier)
                      .fetchSpaces();
                  void manageBackground() async {
                    final dateType = DateTime.now().getTimeOfDayType();
                    if (spaces.length > 1) {
                      game?.updateBackground(
                        "backgrounds/${spaces[1].spaceType}/$dateType.png",
                      );
                    } else {
                      game?.updateBackground(
                        "backgrounds/office/$dateType.png",
                      );
                    }
                  }

                  await ref
                      .read(spacesManagerProvider.notifier)
                      .deleteSpace(space)
                      .then((_) => manageBackground());
                  SnackbarService.showInfoSnackbar(
                      "Space deleted successfully");
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
