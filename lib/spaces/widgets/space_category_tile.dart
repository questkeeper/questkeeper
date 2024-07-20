import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/categories/views/edit_category_bottom_sheet.dart';
import 'package:questkeeper/shared/extensions/color_extensions.dart';
import 'package:questkeeper/shared/extensions/string_extensions.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/task_list/task_item/widgets/task_card.dart';
import 'package:flutter/material.dart';

class SpaceCategoryTile extends StatelessWidget {
  const SpaceCategoryTile({
    super.key,
    required this.category,
    required this.tasks,
    required this.ref,
  });

  final Categories category;
  final List<Tasks>? tasks;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ExpansionTile(
          backgroundColor: category.color != null
              ? category.color!
                  .toColor()
                  .withOpacity(0.6)
                  .blendWith(Colors.black)
              : Colors.transparent.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enableFeedback: true,
          initiallyExpanded: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(LucideIcons.pen),
                onPressed: () {
                  showCategoryBottomSheet(
                      context: context, ref: ref, existingCategory: category);
                },
              ),
            ],
          ),
          collapsedBackgroundColor: category.color
                  ?.toColor()
                  .withOpacity(0.6)
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
              : []),
    );
  }
}
