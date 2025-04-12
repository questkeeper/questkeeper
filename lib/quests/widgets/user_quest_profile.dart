import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/quests/providers/badges_provider.dart';
import 'package:questkeeper/shared/providers/window_size_provider.dart';
import 'package:questkeeper/friends/widgets/user_profile_view.dart';
// import 'package:questkeeper/quests/providers/quests_provider.dart';

/// A responsive widget that displays the user's quest profile information.
/// Automatically adapts between mobile (card-based) and desktop (sidebar) layouts.
class UserQuestProfile extends ConsumerWidget {
  const UserQuestProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ref.watch(isMobileProvider);
    return isMobile
        ? _buildMobileLayout(context, ref)
        : _buildDesktopLayout(context, ref);
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    final pageController = PageController(viewportFraction: 0.92);

    return SizedBox(
      height: 180,
      child: PageView(
        controller: pageController,
        children: [
          const UserProfileView(shouldShowNudgeLimit: false),
          _buildStatsCard(context, ref, isMobile: true),
          // TODO: Uncomment when quests feature is ready
          // _buildHighlightedQuestCard(context, ref),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    final isCompact = ref.watch(isCompactProvider);
    final theme = Theme.of(context);

    return Container(
      width: isCompact ? 280 : 320,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Your Quests',
                style: theme.textTheme.headlineSmall,
              ),
            ),
            const UserProfileView(shouldShowNudgeLimit: false),
            const Divider(height: 1),
            _buildStatsCard(context, ref, isMobile: false),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, WidgetRef ref,
      {required bool isMobile}) {
    final theme = Theme.of(context);
    final userBadgesAsync = ref.watch(badgesManagerProvider);
    final isCompact = isMobile ? true : ref.watch(isCompactProvider);

    Widget statsContent = userBadgesAsync.when(
      data: (data) {
        final (badges, userBadges) = data;
        final redemptionCount = userBadges.isNotEmpty
            ? userBadges.map((ub) => ub.redemptionCount).reduce((a, b) => a + b)
            : 0;
        final activeQuests =
            userBadges.where((ub) => ub.progress > 0 && !ub.redeemed).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMobile) ...[
              Text(
                'Quest Stats',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
            ],
            isMobile
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        context,
                        icon: LucideIcons.check,
                        value: redemptionCount.toString(),
                        label: 'Completed',
                        color: Colors.green,
                        isCompact: isCompact,
                      ),
                      _buildStatItem(
                        context,
                        icon: LucideIcons.clipboard,
                        value: activeQuests.toString(),
                        label: 'Active',
                        color: theme.colorScheme.tertiary,
                        isCompact: isCompact,
                      ),
                      _buildStatItem(
                        context,
                        icon: LucideIcons.flame,
                        value: '0',
                        label: 'Streak',
                        color: Colors.orange,
                        isCompact: isCompact,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem(
                            context,
                            icon: LucideIcons.check,
                            value: redemptionCount.toString(),
                            label: 'Completed',
                            color: Colors.green,
                            isCompact: isCompact,
                          ),
                          _buildStatItem(
                            context,
                            icon: LucideIcons.clipboard,
                            value: activeQuests.toString(),
                            label: 'Active Quests',
                            color: theme.colorScheme.tertiary,
                            isCompact: isCompact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildStatItem(
                        context,
                        icon: LucideIcons.flame,
                        value: '0',
                        label: 'Login streak',
                        color: Colors.orange,
                        isCompact: isCompact,
                      ),
                    ],
                  ),
          ],
        );
      },
      error: (error, _) => const Center(child: Text('Something went wrong')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );

    if (isMobile) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: statsContent,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quest Stats',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          statsContent,
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isCompact,
  }) {
    final theme = Theme.of(context);

    List<Widget> statContent = [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      const SizedBox(width: 12),
      Column(
        crossAxisAlignment:
            isCompact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(12),
      child: isCompact
          ? Column(
              children: [
                statContent[0],
                const SizedBox(height: 8),
                statContent[2],
              ],
            )
          : Row(children: statContent),
    );
  }

  /*
  Widget _buildHighlightedQuest(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userQuestsAsync = ref.watch(questsManagerProvider);

    return userQuestsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text('Error: $error'),
        data: (quests) {
          if (quests.isEmpty) {
            return const Center(
              child: Text('No quests available'),
            );
          }

          // Find the quest with the most progress as percentage
          final highlightedQuest = quests.reduce((a, b) {
            final aProgress = a.progress / a.quest.requirementCount;
            final bProgress = b.progress / b.quest.requirementCount;
            return aProgress > bProgress ? a : b;
          });

          return Card(
            elevation: 0,
            color: theme.colorScheme.secondaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.sparkles,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Today\'s Highlight',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSecondaryContainer
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${highlightedQuest.quest.points} pts',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    highlightedQuest.quest.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    highlightedQuest.quest.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer
                          .withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: highlightedQuest.progress /
                        highlightedQuest.quest.requirementCount,
                    backgroundColor: theme.colorScheme.onSecondaryContainer
                        .withValues(alpha: 0.1),
                    color: theme.colorScheme.onSecondaryContainer
                        .withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${highlightedQuest.progress}/${highlightedQuest.quest.requirementCount}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Go to Quest'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  */
}
