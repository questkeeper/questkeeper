import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/quests/models/badge_model.dart';
import 'package:questkeeper/quests/models/user_badge_model.dart';
import 'package:questkeeper/quests/providers/badges_provider.dart';
import 'package:questkeeper/quests/utils/group_achievements.dart';
import 'package:questkeeper/quests/views/all_achievements_view.dart';
import 'package:questkeeper/quests/widgets/achievement_list.dart';
import 'package:questkeeper/quests/widgets/user_quest_profile.dart';

class MobileQuestsView extends ConsumerWidget {
  const MobileQuestsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(badgesManagerProvider);

    final achievements = badgesAsync.maybeWhen(
      data: (data) => groupAchievements(data),
      orElse: () => <(Badge, UserBadge?)>[],
    );

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            // ignore: unused_result
            ref.refresh(badgesManagerProvider);
          },
          child: ListView(
            children: [
              const UserQuestProfile(),
              _buildAchievementsTab(
                context,
                achievements,
                badgesAsync.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tab for displaying achievements
  Widget _buildAchievementsTab(
    BuildContext context,
    List<(Badge, UserBadge?)> achievements,
    bool isLoading,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton.icon(
                onPressed: () {
                  _showAllAchievements(context, achievements, isLoading);
                },
                icon: const Icon(LucideIcons.list),
                label: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAchievementStats(context, achievements),
          const SizedBox(height: 16),
          AchievementList(
            achievements: achievements,
            loading: isLoading,
            showLimit: true,
            limit: 5,
          ),
        ],
      ),
    );
  }

  // Widget for displaying achievement statistics
  Widget _buildAchievementStats(
    BuildContext context,
    List<(Badge, UserBadge?)> achievements,
  ) {
    final theme = Theme.of(context);
    final totalCount = achievements.length;
    final completedCount =
        achievements.where((a) => a.$2?.redeemed == true).length;
    final completionRate = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Progress',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  LucideIcons.award,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$completedCount of $totalCount achievements completed',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: completionRate,
                        backgroundColor: theme.colorScheme.surface,
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(completionRate * 100).toInt()}% completion rate',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show all achievements in a separate view
  void _showAllAchievements(
    BuildContext context,
    List<(Badge, UserBadge?)> achievements,
    bool isLoading,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AllAchievementsView(
          achievements: achievements,
          isLoading: isLoading,
        ),
      ),
    );
  }
}
