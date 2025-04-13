import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/quests/models/badge_model.dart' as quest_models;
import 'package:questkeeper/quests/models/user_badge_model.dart';
import 'package:questkeeper/quests/widgets/achievement_list.dart';

// Define filter options for achievements
enum AchievementFilter {
  all,
  completed,
  inProgress;

  String get label {
    switch (this) {
      case AchievementFilter.all:
        return 'All';
      case AchievementFilter.completed:
        return 'Completed';
      case AchievementFilter.inProgress:
        return 'In Progress';
    }
  }
}

// Provider for tracking the current filter
final achievementFilterProvider = StateProvider<AchievementFilter>((ref) {
  return AchievementFilter.all;
});

class AllAchievementsView extends ConsumerWidget {
  final List<(quest_models.Badge, UserBadge?)> achievements;
  final bool isLoading;

  const AllAchievementsView({
    super.key,
    required this.achievements,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentFilter = ref.watch(achievementFilterProvider);

    // Apply filtering based on selected filter
    final filteredAchievements =
        _filterAchievements(achievements, currentFilter);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Achievements'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  _buildFilterChip(
                      context, ref, AchievementFilter.all, currentFilter),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                      context, ref, AchievementFilter.completed, currentFilter),
                  const SizedBox(width: 8),
                  _buildFilterChip(context, ref, AchievementFilter.inProgress,
                      currentFilter),
                ],
              ),
            ),

            // Achievement counts summary
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _buildAchievementCounts(theme, achievements),
            ),

            const Divider(),

            // Achievements list
            Expanded(
              child: filteredAchievements.isEmpty && !isLoading
                  ? _buildEmptyState(context)
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: AchievementList(
                        achievements: filteredAchievements,
                        loading: isLoading,
                        showLimit: false,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<(quest_models.Badge, UserBadge?)> _filterAchievements(
    List<(quest_models.Badge, UserBadge?)> achievements,
    AchievementFilter filter,
  ) {
    switch (filter) {
      case AchievementFilter.all:
        return achievements;
      case AchievementFilter.completed:
        return achievements.where((a) => a.$2?.redeemed == true).toList();
      case AchievementFilter.inProgress:
        return achievements
            .where((a) =>
                a.$2 != null && a.$2!.progress > 0 && a.$2!.redeemed != true)
            .toList();
    }
  }

  Widget _buildFilterChip(
    BuildContext context,
    WidgetRef ref,
    AchievementFilter filter,
    AchievementFilter currentFilter,
  ) {
    final theme = Theme.of(context);
    final isSelected = filter == currentFilter;

    return FilterChip(
      selected: isSelected,
      label: Text(filter.label),
      showCheckmark: false,
      avatar: Icon(
        _getFilterIcon(filter),
        size: 18,
        color: isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.primary,
      ),
      onSelected: (selected) {
        if (selected) {
          ref.read(achievementFilterProvider.notifier).state = filter;
        }
      },
    );
  }

  IconData _getFilterIcon(AchievementFilter filter) {
    switch (filter) {
      case AchievementFilter.all:
        return LucideIcons.layers;
      case AchievementFilter.completed:
        return LucideIcons.check;
      case AchievementFilter.inProgress:
        return LucideIcons.hourglass;
    }
  }

  Widget _buildAchievementCounts(
    ThemeData theme,
    List<(quest_models.Badge, UserBadge?)> achievements,
  ) {
    final completedCount =
        achievements.where((a) => a.$2?.redeemed == true).length;
    final inProgressCount = achievements
        .where(
            (a) => a.$2 != null && a.$2!.progress > 0 && a.$2!.redeemed != true)
        .length;
    final totalCount = achievements.length;

    return Row(
      children: [
        Text(
          'Total: $totalCount',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(width: 16),
        Icon(
          LucideIcons.check,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          '$completedCount',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Icon(
          LucideIcons.hourglass,
          size: 16,
          color: theme.colorScheme.secondary,
        ),
        const SizedBox(width: 4),
        Text(
          '$inProgressCount',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.award,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No achievements found',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Try changing your filter to see more achievements',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: () {
                // Reset filter
                final filterNotifier = achievementFilterProvider.notifier;
                if (context.mounted) {
                  context
                      .findAncestorStateOfType<ConsumerState>()
                      ?.ref
                      .read(filterNotifier)
                      .state = AchievementFilter.all;
                }
              },
              child: const Text('Show All Achievements'),
            ),
          ],
        ),
      ),
    );
  }
}
