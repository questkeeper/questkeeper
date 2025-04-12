import 'package:questkeeper/quests/models/user_quest_model.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:questkeeper/shared/utils/http_service.dart';

class QuestsRepository {
  QuestsRepository();

  final HttpService _httpService = HttpService();

  // Get active quests for the current user
  Future<List<UserQuest>> getActiveQuests() async {
    final response = await _httpService.get('/quests/active');
    final List<dynamic> data = response.data;
    return data.map((e) => UserQuest.fromMap(e)).toList();
  }

  // Get completed quests history
  Future<List<UserQuest>> getCompletedQuests() async {
    final response = await _httpService.get('/quests/completed');
    final List<dynamic> data = response.data;
    return data.map((e) => UserQuest.fromMap(e)).toList();
  }

  // Update progress on a quest
  Future<ReturnModel> updateQuestProgress(int questId, int progress) async {
    final response = await _httpService.post(
      '/quests/$questId/progress',
      data: {'progress': progress},
    );

    final jsonResponse = response.data;
    return ReturnModel(
      data: jsonResponse,
      message: jsonResponse['message'] ?? 'Progress updated',
      success: jsonResponse['success'] ?? false,
      error: jsonResponse['error'],
    );
  }

  // Reroll a quest
  Future<ReturnModel> rerollQuest(int questId) async {
    final response = await _httpService.post('/quests/$questId/reroll');

    final jsonResponse = response.data;
    return ReturnModel(
      data: jsonResponse,
      message: jsonResponse['message'] ?? 'Quest rerolled',
      success: jsonResponse['success'] ?? false,
      error: jsonResponse['error'],
    );
  }

  // Mark a quest as completed
  Future<ReturnModel> completeQuest(int questId) async {
    final response = await _httpService.post('/quests/$questId/complete');

    final jsonResponse = response.data;
    return ReturnModel(
      data: jsonResponse,
      message: jsonResponse['message'] ?? 'Quest completed',
      success: jsonResponse['success'] ?? false,
      error: jsonResponse['error'],
    );
  }

  // Redeem a completed quest
  Future<ReturnModel> redeemQuest(int questId) async {
    final response = await _httpService.post('/quests/$questId/redeem');

    final jsonResponse = response.data;
    return ReturnModel(
      data: jsonResponse,
      message: jsonResponse['message'] ?? 'Quest redeemed',
      success: jsonResponse['success'] ?? false,
      error: jsonResponse['error'],
    );
  }
}
