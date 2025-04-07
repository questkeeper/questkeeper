import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/quests/models/badge_model.dart' as quest_models;
import 'package:questkeeper/quests/models/user_badge_model.dart';
import 'package:questkeeper/quests/providers/badges_provider.dart';
import 'package:questkeeper/quests/widgets/custom_progress_bar.dart';
import 'package:questkeeper/shared/widgets/empty_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AchievementList extends ConsumerStatefulWidget {
  const AchievementList({
    super.key,
    required this.achievements,
    this.loading = false,
    this.showLimit = true,
    this.limit = 3,
  });
  final List<(quest_models.Badge, UserBadge?)> achievements;
  final bool loading;
  final bool showLimit;
  final int limit;

  @override
  ConsumerState<AchievementList> createState() => _AchievementListState();
}

class _AchievementListState extends ConsumerState<AchievementList> {
  @override
  Widget build(BuildContext context) {
    final achievements = widget.achievements;
    final loading = widget.loading;
    final showLimit = widget.showLimit;
    final limit = widget.limit;

    final theme = Theme.of(context);
    final displayedAchievements =
        showLimit ? achievements.take(limit).toList() : achievements;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        if (loading) ...[
          _buildSkeletonList(theme),
        ] else if (displayedAchievements.isEmpty) ...[
          const EmptyState(
            title: "No achievements available yet",
            icon: LucideIcons.award,
          ),
        ] else ...[
          ...displayedAchievements
              .map((achievement) => _buildAchievementItem(theme, achievement)),
        ],
      ],
    );
  }

  Widget _buildSkeletonList(ThemeData theme) {
    final now = DateTime.now();
    final monthYear = "${now.month}-${now.year}";

    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
          widget.limit,
          (index) => _buildAchievementItem(
            theme,
            (
              quest_models.Badge(
                id: 'badge_$index',
                name: 'Loading Achievement',
                description:
                    'This is a placeholder description for the achievement while loading.',
                points: 100,
                requirementCount: 100,
                category: 'loading',
                tier: 1,
                resetMonthly: false,
              ),
              UserBadge(
                id: index,
                badge: quest_models.Badge(
                  id: 'badge_$index',
                  name: 'Loading',
                  description: 'Loading',
                  points: 100,
                  requirementCount: 100,
                  category: 'loading',
                  tier: 1,
                  resetMonthly: false,
                ),
                progress: 50,
                earnedAt: null,
                redeemed: false,
                monthYear: monthYear,
                redemptionCount: 0,
              )
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementItem(
      ThemeData theme, (quest_models.Badge, UserBadge?) achievement) {
    final badge = achievement.$1;
    final userBadge = achievement.$2;

    final progress = userBadge?.progress ?? 0;
    final progressRatio = progress > badge.requirementCount
        ? 1.0
        : progress / badge.requirementCount;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: userBadge?.redeemed == true
                        ? Border.all(color: Colors.amber)
                        : null,
                    color: progressRatio == 1.0
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    LucideIcons.award,
                    color: progressRatio == 1.0
                        ? userBadge?.redeemed == true
                            ? Colors.amber
                            : theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        badge.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        badge.description,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${badge.points} points',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (badge.resetMonthly) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Monthly',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomProgressBar(
              progress: progressRatio,
              label: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userBadge?.redeemed == true ? 'Completed' : 'Progress',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: userBadge?.redeemed == true
                            ? theme.colorScheme.primary
                            : null,
                      ),
                    ),
                    Text(
                      '${userBadge?.progress ?? 0}/${badge.requirementCount}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              progressColor: userBadge?.redeemed == true
                  ? theme.colorScheme.primary
                  : null,
            ),
            if (userBadge?.redeemed != true && progressRatio == 1.0) ...[
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  ref
                      .read(badgesManagerProvider.notifier)
                      .redeemBadge(userBadge!.id);
                },
                icon: const Icon(LucideIcons.gift),
                label: const Text('Redeem'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
