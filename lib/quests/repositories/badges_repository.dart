import 'package:questkeeper/quests/models/badge_model.dart';
import 'package:questkeeper/quests/models/user_badge_model.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:questkeeper/shared/utils/http_service.dart';

class BadgesRepository {
  BadgesRepository();

  final HttpService _httpService = HttpService();

  Future<List<Badge>> getBadges() async {
    final response = await _httpService.get('/social/badges');
    final List<dynamic> data = response.data;
    return data.map((e) => Badge.fromMap(e)).toList();
  }

  Future<List<UserBadge>> getUserBadges() async {
    final response = await _httpService.get('/social/badges/me');
    final List<dynamic> data = response.data;
    return data.map((e) => UserBadge.fromMap(e)).toList();
  }

  Future<ReturnModel> redeemBadge(int userBadgeId) async {
    final response =
        await _httpService.post('/social/badges/$userBadgeId/redeem');

    final jsonResponse = response.data;

    return ReturnModel(
      data: jsonResponse,
      message: jsonResponse['pointsAwarded'].toString(),
      success: jsonResponse['success'] ?? false,
      error: jsonResponse['error'],
    );
  }
}
