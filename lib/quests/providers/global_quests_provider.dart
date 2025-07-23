import 'package:flutter/foundation.dart';
import 'package:questkeeper/quests/models/global_quest_model.dart';
import 'package:questkeeper/quests/models/user_global_quest_contribution_model.dart';
import 'package:questkeeper/quests/repositories/global_quests_repository.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_quests_provider.g.dart';

@riverpod
class GlobalQuestManager extends _$GlobalQuestManager {
  // ignore: unused_field
  final GlobalQuestsRepository _repository;

  GlobalQuestManager() : _repository = GlobalQuestsRepository();

  @override
  FutureOr<GlobalQuest> build() {
    return fetchGlobalQuest();
  }

  Future<GlobalQuest> fetchGlobalQuest() async {
    try {
      // GlobalQuest quest = await _repository.getCurrentGlobalQuest();
      GlobalQuest quest = GlobalQuest(
        id: 'global_debug_1',
        title: 'Community Goal: Complete 500 Tasks',
        description:
            'Work together with the community to reach 500 completed tasks this week!',
        goalValue: 500,
        currentValue: 250,
        participantCount: 1248,
        rewardPoints: 1000,
        startDate: DateTime.now().toIso8601String(),
        endDate: DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      );

      // Add dummy data if in debug mode and API returns a null or empty quest
      if (kDebugMode && quest.id.isEmpty) {
        final now = DateTime.now();
        final endDate = now.add(const Duration(days: 7));

        quest = GlobalQuest(
          id: 'global_debug_1',
          title: 'Community Goal: Complete 500 Tasks',
          description:
              'Work together with the community to reach 500 completed tasks this week!',
          goalValue: 500,
          currentValue: 250,
          participantCount: 1248,
          rewardPoints: 1000,
          startDate: now.toIso8601String(),
          endDate: endDate.toIso8601String(),
        );
      }

      return quest;
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception("Failed to fetch global quest: $error");
    }
  }

  Future<void> refreshGlobalQuest() async {
    state = const AsyncValue.loading();
    try {
      final quest = await fetchGlobalQuest();
      state = AsyncValue.data(quest);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}

@riverpod
class UserGlobalQuestContributionManager
    extends _$UserGlobalQuestContributionManager {
  final GlobalQuestsRepository _repository;

  UserGlobalQuestContributionManager() : _repository = GlobalQuestsRepository();

  @override
  FutureOr<UserGlobalQuestContribution> build() {
    return fetchUserContribution();
  }

  Future<UserGlobalQuestContribution> fetchUserContribution() async {
    try {
      UserGlobalQuestContribution contribution =
          await _repository.getUserContribution();

      // Add dummy data if in debug mode
      if (kDebugMode && contribution.contributionValue == 0) {
        contribution = UserGlobalQuestContribution(
          id: 999,
          globalQuestId: 'global_debug_1',
          contributionValue: 12,
          lastContributedAt: DateTime.now()
              .subtract(const Duration(hours: 5))
              .toIso8601String(),
        );
      }

      return contribution;
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception("Failed to fetch user contribution: $error");
    }
  }

  Future<void> refreshUserContribution() async {
    state = const AsyncValue.loading();
    try {
      final contribution = await fetchUserContribution();
      state = AsyncValue.data(contribution);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  Future<ReturnModel> contributeToGlobalQuest(
      String globalQuestId, int contributionValue) async {
    try {
      final result = await _repository.contributeToGlobalQuest(
          globalQuestId, contributionValue);
      if (result.success) {
        await refreshUserContribution();
      }
      return result;
    } catch (error) {
      return ReturnModel(
        success: false,
        error: error.toString(),
        message: 'Failed to record contribution',
      );
    }
  }
}

@riverpod
class GlobalQuestsHistoryManager extends _$GlobalQuestsHistoryManager {
  final GlobalQuestsRepository _repository;

  GlobalQuestsHistoryManager() : _repository = GlobalQuestsRepository();

  @override
  FutureOr<List<GlobalQuest>> build() {
    return fetchGlobalQuestsHistory();
  }

  Future<List<GlobalQuest>> fetchGlobalQuestsHistory() async {
    try {
      List<GlobalQuest> quests = await _repository.getGlobalQuestHistory();

      // Add dummy data if in debug mode
      if (kDebugMode && quests.isEmpty) {
        final now = DateTime.now();
        quests.addAll([
          GlobalQuest(
            id: 'global_debug_2',
            title: 'Past Global Quest: 1000 Comments',
            description: 'The community worked together to post 1000 comments.',
            goalValue: 1000,
            currentValue: 1000,
            participantCount: 823,
            rewardPoints: 800,
            startDate: now.subtract(const Duration(days: 30)).toIso8601String(),
            endDate: now.subtract(const Duration(days: 15)).toIso8601String(),
            completed: true,
          ),
          GlobalQuest(
            id: 'global_debug_3',
            title: 'Past Global Quest: 300 Tags',
            description:
                'The community worked together to create 300 unique tags.',
            goalValue: 300,
            currentValue: 287,
            participantCount: 523,
            rewardPoints: 500,
            startDate: now.subtract(const Duration(days: 60)).toIso8601String(),
            endDate: now.subtract(const Duration(days: 45)).toIso8601String(),
            completed: false,
          ),
        ]);
      }

      return quests;
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception("Failed to fetch global quests history: $error");
    }
  }

  Future<void> refreshGlobalQuestsHistory() async {
    state = const AsyncValue.loading();
    try {
      final quests = await fetchGlobalQuestsHistory();
      state = AsyncValue.data(quests);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}
