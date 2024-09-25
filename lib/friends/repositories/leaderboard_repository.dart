import 'package:questkeeper/constants.dart';
import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaderboardRepository {
  LeaderboardRepository();
  final header = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization':
        'Bearer ${Supabase.instance.client.auth.currentSession!.accessToken}'
  };

  Future<List<Friend>> fetchFriendLeaderboard(String? range) async {
    final response = await http.get(
        Uri.parse('$baseApiUri/social/leaderboard/friend?range=$range'),
        headers: header);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      final friendsList = data.map((json) => Friend.fromMap(json)).toList();

      return friendsList;
    } else {
      throw Exception('Failed to load leaderboard');
    }
  }

  Future<List<Friend>> fetchGlobalLeaderboard(String? range) async {
    final response = await http.get(
        Uri.parse('$baseApiUri/social/leaderboard/global?range=$range'),
        headers: header);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      final friendsList = data.map((json) => Friend.fromMap(json)).toList();

      return friendsList;
    } else {
      throw Exception('Failed to load global leaderboard');
    }
  }
}
