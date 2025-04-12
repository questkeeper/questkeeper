import 'package:flutter/material.dart';
import 'package:questkeeper/quests/widgets/quest_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizedQuestGrid extends StatelessWidget {
  final bool isLoading;
  final List<Widget>? children;
  final int columns;
  final double spacing;
  final int placeholderCount;

  const SkeletonizedQuestGrid({
    super.key,
    required this.isLoading,
    this.children,
    this.columns = 3,
    this.spacing = 16.0,
    this.placeholderCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Skeletonizer(
        enabled: true,
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: columns,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: 1.0,
          children: List.generate(
            placeholderCount,
            (index) => QuestCard(
              title: 'Loading Quest ${index + 1}',
              description:
                  'This quest is currently loading. Please wait a moment.',
              points: 100 * (index + 1),
              progress: 0.25 * (index + 1),
              goalValue: 100,
              currentValue: (25 * (index + 1)).toInt(),
              isLoading: true,
            ),
          ),
        ),
      );
    }

    if (children == null || children!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.assignment_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                "No quests available at the moment",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: columns,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      childAspectRatio: 1.0,
      children: children!,
    );
  }
}
