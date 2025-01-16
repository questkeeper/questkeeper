import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/categories/providers/category_collapse_state_provider.dart';
import 'package:questkeeper/categories/views/edit_category_bottom_sheet.dart';
import 'package:questkeeper/shared/extensions/color_extensions.dart';
import 'package:questkeeper/shared/extensions/string_extensions.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/task_list/task_item/widgets/task_card.dart';
import 'package:flutter/material.dart';

class SpaceCategoryTile extends ConsumerWidget {
  const SpaceCategoryTile({
    super.key,
    required this.category,
    required this.tasks,
  });

  final Categories category;
  final List<Tasks>? tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryCollapseStateAsync = ref.watch(categoryCollapseStateProvider);

    return categoryCollapseStateAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (collapseState) {
        final isCollapsed =
            (collapseState[category.id] ?? false) || category.id == null;

        return Container(
          margin:
              category.id == null ? const EdgeInsets.only(bottom: 48) : null,
          padding: const EdgeInsets.all(8),
          child: ExpansionTile(
            key: PageStorageKey(category.id),
            backgroundColor: category.color != null
                ? category.color!
                    .toColor()
                    .withValues(alpha: 0.6)
                    .blendWith(Colors.black)
                : Colors.transparent.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enableFeedback: true,
            initiallyExpanded: !isCollapsed,
            onExpansionChanged: (expanded) {
              if (category.id != null) {
                ref
                    .read(categoryCollapseStateProvider.notifier)
                    .toggleCategory(category.id!);
              }
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    category.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                category.id != null
                    ? IconButton(
                        icon: const Icon(LucideIcons.pen),
                        onPressed: () {
                          showCategoryBottomSheet(
                              context: context,
                              ref: ref,
                              existingCategory: category);
                        },
                      )
                    : Container(),
              ],
            ),
            collapsedBackgroundColor: category.color
                    ?.toColor()
                    .withValues(alpha: 0.6)
                    .blendWith(Colors.black) ??
                Colors.transparent,
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            children: tasks?.isNotEmpty == true && tasks != null
                ? tasks!
                    .map((task) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: TaskCard(
                          task: task,
                          key: ValueKey(task.id),
                        )))
                    .toList()
                : [],
          ),
        );
      },
    );
  }
}
