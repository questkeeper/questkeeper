import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/shared/utils/http_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LeaderboardRepository {
  final HttpService _httpService = HttpService();

  Future<List<Friend>> fetchFriendLeaderboard(String? range) async {
    try {
      final response = await _httpService.get(
        '/social/leaderboard/friend',
        queryParameters: {'range': range},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Friend.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load leaderboard');
      }
    } catch (error) {
      Sentry.captureException(error);
      throw Exception('Failed to load leaderboard');
    }
  }

  Future<List<Friend>> fetchGlobalLeaderboard(String? range) async {
    try {
      final response = await _httpService.get(
        '/social/leaderboard/global',
        queryParameters: {'range': range},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Friend.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load global leaderboard');
      }
    } catch (error) {
      Sentry.captureException(error);
      throw Exception('Failed to load global leaderboard');
    }
  }
}
