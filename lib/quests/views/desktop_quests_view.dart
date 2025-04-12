import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/quests/models/badge_model.dart' as quest_models;
import 'package:questkeeper/quests/models/user_badge_model.dart';
import 'package:questkeeper/quests/providers/badges_provider.dart';
import 'package:questkeeper/quests/utils/group_achievements.dart';
import 'package:questkeeper/quests/views/all_achievements_view.dart';
import 'package:questkeeper/quests/widgets/achievement_list.dart';
import 'package:questkeeper/quests/widgets/desktop/user_quest_profile.dart';
// import 'package:questkeeper/quests/widgets/global_quest_card.dart';
// import 'package:questkeeper/quests/widgets/quest_card.dart';
// import 'package:questkeeper/quests/widgets/skeletonized_quest_grid.dart';
// import 'package:questkeeper/quests/providers/global_quests_provider.dart';
// import 'package:questkeeper/quests/providers/quests_provider.dart';
// import 'package:questkeeper/shared/widgets/snackbar.dart';

class DesktopQuestsView extends ConsumerStatefulWidget {
  const DesktopQuestsView({super.key});

  @override
  ConsumerState<DesktopQuestsView> createState() => _DesktopQuestsViewState();
}

class _DesktopQuestsViewState extends ConsumerState<DesktopQuestsView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgesAsync = ref.watch(badgesManagerProvider);

    // Using the new providers
    // final globalQuestAsync = ref.watch(globalQuestManagerProvider);
    // final userQuestsAsync = ref.watch(questsManagerProvider);

    // Convert badge data to format needed for achievement list
    final achievements = badgesAsync.maybeWhen(
      data: (data) => groupAchievements(data),
      orElse: () => <(quest_models.Badge, UserBadge?)>[],
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          children: [
            // Left panel - User Stats & Quest Summary
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 24,
              ),
              child: UserQuestProfile(),
            ),

            // Main content area - Quests and Global Challenges
            Expanded(
              child: Material(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Quests & Challenges',
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*
                              // Global Quest Section
                              globalQuestAsync.when(
                                loading: () => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                error: (error, _) => Text('Error: $error'),
                                data: (globalQuest) => GlobalQuestCard(
                                  title: globalQuest.title,
                                  description: globalQuest.description,
                                  progress: globalQuest.progress,
                                  goalValue: globalQuest.goalValue,
                                  currentValue: globalQuest.currentValue,
                                  rewardPoints: globalQuest.rewardPoints,
                                  endDate: DateTime.parse(globalQuest.endDate),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Active Quests Section
                              Text(
                                'Active Quests',
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),

                              // Using the quests provider for the quest grid
                              userQuestsAsync.when(
                                loading: () => SkeletonizedQuestGrid(
                                  isLoading: true,
                                  columns: 3,
                                  spacing: 16,
                                ),
                                error: (error, _) => Text('Error: $error'),
                                data: (userQuests) => SkeletonizedQuestGrid(
                                  isLoading: false,
                                  columns: 3,
                                  spacing: 16,
                                  children: userQuests.map((userQuest) {
                                    return QuestCard(
                                      title: userQuest.quest.title,
                                      description: userQuest.quest.description,
                                      points: userQuest.quest.points,
                                      progress: userQuest.progress /
                                          userQuest.quest.requirementCount,
                                      goalValue:
                                          userQuest.quest.requirementCount,
                                      currentValue: userQuest.progress,
                                      id: userQuest.quest.id,
                                      onReroll: () =>
                                          _handleQuestReroll(userQuest.id),
                                    );
                                  }).toList(),
                                ),
                              ),

                              const SizedBox(height: 24),
                              */

                              // Achievements Section
                              _buildTopAchievements(
                                  context, achievements, badgesAsync.isLoading),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAchievements(
    BuildContext context,
    List<(quest_models.Badge, UserBadge?)> achievements,
    bool isLoading,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Achievements',
              style: Theme.of(context).textTheme.titleLarge,
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
        AchievementList(
          achievements: achievements,
          loading: isLoading,
          limit: 5,
          showLimit: true,
        ),
      ],
    );
  }
/*
  void _handleQuestReroll(int questId) {
    // Use the quest manager to reroll a quest
    ref
        .read(questsManagerProvider.notifier)
        .rerollQuest(questId)
        .then((result) {
      if (result.success) {
        SnackbarService.showSuccessSnackbar(result.message);
      } else {
        SnackbarService.showErrorSnackbar(
            result.error ?? 'Failed to reroll quest');
      }
    });
  }
*/

  void _showAllAchievements(
    BuildContext context,
    List<(quest_models.Badge, UserBadge?)> achievements,
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
