import 'package:flutter/foundation.dart';
import 'package:questkeeper/quests/models/quest_model.dart';
import 'package:questkeeper/quests/models/user_quest_model.dart';
import 'package:questkeeper/quests/repositories/quests_repository.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quests_provider.g.dart';

@riverpod
class QuestsManager extends _$QuestsManager {
  final QuestsRepository _repository;

  QuestsManager() : _repository = QuestsRepository();

  @override
  FutureOr<List<UserQuest>> build() {
    return fetchActiveQuests();
  }

  Future<List<UserQuest>> fetchActiveQuests() async {
    try {
      // List<UserQuest> quests = await _repository.getActiveQuests();
      List<UserQuest> quests = [];

      // Add dummy data if in debug mode
      if (kDebugMode) {
        final now = DateTime.now().toIso8601String();
        quests.addAll([
          UserQuest(
            id: 999,
            quest: Quest(
              id: 'debug_quest_1',
              title: 'Debug Quest 1',
              description: 'This is a debug quest for testing',
              points: 150,
              requirementCount: 5,
              category: 'debug',
              type: 'task',
            ),
            progress: 2,
            assignedAt: now,
          ),
          UserQuest(
            id: 998,
            quest: Quest(
              id: 'debug_quest_2',
              title: 'Debug Quest 2',
              description: 'Another debug quest for testing',
              points: 300,
              requirementCount: 10,
              category: 'debug',
              type: 'tag',
            ),
            progress: 5,
            assignedAt: now,
          ),
        ]);
      }

      return quests;
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception("Failed to fetch active quests: $error");
    }
  }

  Future<void> refreshQuests() async {
    state = const AsyncValue.loading();
    try {
      final quests = await fetchActiveQuests();
      state = AsyncValue.data(quests);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  Future<ReturnModel> updateQuestProgress(int questId, int progress) async {
    try {
      final result = await _repository.updateQuestProgress(questId, progress);
      if (result.success) {
        await refreshQuests();
      }
      return result;
    } catch (error) {
      return ReturnModel(
        success: false,
        error: error.toString(),
        message: 'Failed to update quest progress',
      );
    }
  }

  Future<ReturnModel> rerollQuest(int questId) async {
    try {
      final result = await _repository.rerollQuest(questId);
      if (result.success) {
        await refreshQuests();
      }
      return result;
    } catch (error) {
      return ReturnModel(
        success: false,
        error: error.toString(),
        message: 'Failed to reroll quest',
      );
    }
  }

  Future<ReturnModel> completeQuest(int questId) async {
    try {
      final result = await _repository.completeQuest(questId);
      if (result.success) {
        await refreshQuests();
      }
      return result;
    } catch (error) {
      return ReturnModel(
        success: false,
        error: error.toString(),
        message: 'Failed to complete quest',
      );
    }
  }

  Future<ReturnModel> redeemQuest(int questId) async {
    try {
      final result = await _repository.redeemQuest(questId);
      if (result.success) {
        await refreshQuests();
      }
      return result;
    } catch (error) {
      return ReturnModel(
        success: false,
        error: error.toString(),
        message: 'Failed to redeem quest',
      );
    }
  }
}

@riverpod
class CompletedQuestsManager extends _$CompletedQuestsManager {
  final QuestsRepository _repository;

  CompletedQuestsManager() : _repository = QuestsRepository();

  @override
  FutureOr<List<UserQuest>> build() {
    return fetchCompletedQuests();
  }

  Future<List<UserQuest>> fetchCompletedQuests() async {
    try {
      List<UserQuest> quests = await _repository.getCompletedQuests();

      // Add dummy data if in debug mode
      if (kDebugMode) {
        final now = DateTime.now().toIso8601String();
        final yesterday =
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String();
        quests.addAll([
          UserQuest(
            id: 997,
            quest: Quest(
              id: 'debug_quest_3',
              title: 'Completed Debug Quest',
              description: 'A completed debug quest for testing',
              points: 200,
              requirementCount: 3,
              category: 'debug',
              type: 'task',
            ),
            progress: 3,
            completed: true,
            redeemed: true,
            completedAt: yesterday,
            assignedAt: yesterday,
          ),
          UserQuest(
            id: 996,
            quest: Quest(
              id: 'debug_quest_4',
              title: 'Completed but not Redeemed',
              description: 'A completed but not redeemed debug quest',
              points: 250,
              requirementCount: 5,
              category: 'debug',
              type: 'streak',
            ),
            progress: 5,
            completed: true,
            redeemed: false,
            completedAt: now,
            assignedAt: yesterday,
          ),
        ]);
      }

      return quests;
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception("Failed to fetch completed quests: $error");
    }
  }

  Future<void> refreshCompletedQuests() async {
    state = const AsyncValue.loading();
    try {
      final quests = await fetchCompletedQuests();
      state = AsyncValue.data(quests);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}
