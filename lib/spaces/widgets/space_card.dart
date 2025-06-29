import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/categories/views/edit_category_bottom_sheet.dart';
import 'package:questkeeper/shared/extensions/datetime_extensions.dart';
import 'package:questkeeper/shared/extensions/string_extensions.dart';
import 'package:questkeeper/shared/providers/window_size_provider.dart';
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
import 'package:skeletonizer/skeletonizer.dart';

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
    _scrollController.removeListener(_onScroll);
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
    } else if (!_isMinimized &&
        _scrollController.offset <= 0 &&
        _scrollController.offset >= -10) {
      ref.read(gameHeightProvider.notifier).state = 1.0;
      _resetScrollListener();
    }

    _resetScrollListener();
  }

  /// A hacky way to ensure onScroll isn't called again due to the bounce effect/
  /// list height being too small
  void _resetScrollListener() {
    if (!mounted) return;
    _scrollController.removeListener(_onScroll);

    // 200ms delay to prevent multiple calls
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      _scrollController.addListener(_onScroll);
    });
  }

  @override
  Widget build(BuildContext context) {
    final space = widget.space;
    final tasks = ref.watch(tasksManagerProvider.select((value) =>
        value.value?.where((task) => task.spaceId == space.id).toList()));
    final gameHeight = ref.watch(gameHeightProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = ref.watch(isMobileProvider);

    final currentSpaceCategories = ref.watch(categoriesManagerProvider
        .select((value) => value.value?.where((category) {
              return category.spaceId == space.id;
            }).toList()));

    return Container(
      color: widget.backgroundColorHex.toColor(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    space.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(height: 1),
                  ),
                ),
                if (isMobile)
                  IconButton(
                    color: Theme.of(context).colorScheme.onSurface,
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
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                return false;
              },
              child: currentSpaceCategories == null
                  ? Skeletonizer(
                      enabled: true,
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    Colors.transparent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: SizedBox(
                                height: 64,
                                width: double.infinity,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: currentSpaceCategories.length + 1,
                      itemBuilder: (context, index) {
                        final categoryTasksList = tasks?.where((task) {
                          return task.categoryId ==
                              (index < currentSpaceCategories.length
                                  ? currentSpaceCategories[index].id
                                  : null);
                        }).toList();
                        if (index < currentSpaceCategories.length) {
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
                                  child: FilledButton.icon(
                                    onPressed: () => showCategoryBottomSheet(
                                      context: context,
                                      ref: ref,
                                      existingSpace: space,
                                    ),
                                    icon: const Icon(LucideIcons.folder_plus),
                                    label: const Text('Create a category'),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'Or create a task and an "uncategorized" category will be created automatically',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: colorScheme.onSurface,
                                        ),
                                  ),
                                ),
                                const SizedBox(
                                  height: kBottomNavigationBarHeight + 48,
                                ),
                              ],
                            );
                          }

                          return const SizedBox(
                            height: kBottomNavigationBarHeight + 48,
                          );
                        }
                      },
                    ),
            ),
          ),
        ],
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
    final isMobile = ref.watch(isMobileProvider);

    return PopupMenuButton<SpaceAction>(
      icon: Icon(
        isMobile ? LucideIcons.menu : LucideIcons.ellipsis_vertical,
      ),
      iconColor: Theme.of(context).colorScheme.onSurface,
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
