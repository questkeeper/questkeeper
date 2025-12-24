import 'package:questkeeper/quests/models/global_quest_model.dart';
import 'package:questkeeper/quests/models/user_global_quest_contribution_model.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:questkeeper/shared/utils/http_service.dart';

class GlobalQuestsRepository {
  GlobalQuestsRepository();

  final HttpService _httpService = HttpService();

  // Get current global quest
  Future<GlobalQuest> getCurrentGlobalQuest() async {
    final response = await _httpService.get('/quests/global');
    return GlobalQuest.fromJson(response.data);
  }

  // Get user's contribution to current global quest
  Future<UserGlobalQuestContribution> getUserContribution() async {
    final response = await _httpService.get('/quests/global/contribution');
    return UserGlobalQuestContribution.fromJson(response.data);
  }

  // Get global quest statistics
  Future<Map<String, dynamic>> getGlobalQuestStats() async {
    final response = await _httpService.get('/quests/global/stats');
    return response.data;
  }

  // Contribute to global quest (typically done automatically when completing relevant quests)
  Future<ReturnModel> contributeToGlobalQuest(
      String globalQuestId, int contributionValue) async {
    final response = await _httpService.post(
      '/quests/global/$globalQuestId/contribute',
      data: {'contributionValue': contributionValue},
    );

    final jsonResponse = response.data;
    return ReturnModel(
      data: jsonResponse,
      message: jsonResponse['message'] ?? 'Contribution recorded',
      success: jsonResponse['success'] ?? false,
      error: jsonResponse['error'],
    );
  }

  // Get history of global quests
  Future<List<GlobalQuest>> getGlobalQuestHistory() async {
    final response = await _httpService.get('/quests/global/history');
    final List<dynamic> data = response.data;
    return data.map((e) => GlobalQuest.fromJson(e)).toList();
  }
}
