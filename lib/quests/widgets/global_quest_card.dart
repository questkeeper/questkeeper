import 'package:flutter/material.dart';
import 'package:questkeeper/quests/widgets/custom_progress_bar.dart';

class GlobalQuestCard extends StatelessWidget {
  final String title;
  final String description;
  final double progress;
  final int goalValue;
  final int currentValue;
  final int? rewardPoints;
  final bool isLoading;
  final DateTime? endDate;

  const GlobalQuestCard({
    super.key,
    required this.title,
    required this.description,
    required this.progress,
    required this.goalValue,
    required this.currentValue,
    this.rewardPoints,
    this.isLoading = false,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withAlpha(30),
              theme.colorScheme.secondary.withAlpha(10),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.public,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Global Quest',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                if (endDate != null) ...[
                  const Spacer(),
                  _buildTimeRemaining(context, endDate!),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            CustomProgressBar(
              progress: progress,
              height: 20,
              showPercentage: true,
              progressColor: theme.colorScheme.primary,
              backgroundColor:
                  theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
              label: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quest Progress',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$currentValue/$goalValue',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            if (rewardPoints != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.stars,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Reward: $rewardPoints points upon completion',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRemaining(BuildContext context, DateTime endDate) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final difference = endDate.difference(now);

    if (difference.isNegative) {
      return const Text('Expired');
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, size: 14),
          const SizedBox(width: 4),
          Text(
            days > 0
                ? '$days days${hours > 0 ? ', $hours hrs' : ''} left'
                : '${difference.inHours} hours left',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
