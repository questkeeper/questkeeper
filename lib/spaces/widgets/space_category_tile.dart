import 'package:assigngo_rewrite/categories/models/categories_model.dart';
import 'package:assigngo_rewrite/shared/utils/hex_color.dart';
import 'package:assigngo_rewrite/task_list/task_item/widgets/task_card.dart';
import 'package:flutter/material.dart';

class SpaceCategoryTile extends StatelessWidget {
  const SpaceCategoryTile({
    super.key,
    required this.category,
  });

  final Categories category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ExpansionTile(
        backgroundColor: category.color != null
            ? HexColor(category.color!).withOpacity(0.6)
            : Colors.transparent.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enableFeedback: true,
        initiallyExpanded: true,
        title: Text(category.title,
            style: Theme.of(context).textTheme.titleMedium),
        children: category.tasks!
            .map((task) => Container(
                  margin: const EdgeInsets.all(8.0),
                  child: TaskCard(
                    key: ValueKey(task.id),
                    task: task,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
