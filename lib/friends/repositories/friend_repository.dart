import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:questkeeper/constants.dart';
import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/friends/models/user_search_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendRepository {
  FriendRepository();
  final header = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization':
        'Bearer ${Supabase.instance.client.auth.currentSession!.accessToken}'
  };

  Future<List<Friend>> fetchFriends() async {
    final response = await http.get(Uri.parse('$baseApiUri/social/friends'),
        headers: header);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      final friendsList = data.map((json) => Friend.fromMap(json)).toList();

      return friendsList;
    } else {
      throw Exception('Failed to load friends');
    }
  }

  Future<Map<String, List<UserSearchResult>>> fetchPendingFriends() async {
    final response = await http
        .get(Uri.parse('$baseApiUri/social/friends/pending'), headers: header);

    try {
      if (response.statusCode == 200) {
        List<UserSearchResult> sentRequests = json
            .decode(response.body)['sent']
            .map<UserSearchResult>((json) => UserSearchResult.fromMap(json))
            .toList();

        List<UserSearchResult> receivedRequests = json
            .decode(response.body)['received']
            .map<UserSearchResult>((json) => UserSearchResult.fromMap(json))
            .toList();

        return {'sent': sentRequests, 'received': receivedRequests};
      } else {
        debugPrint(response.body);
        throw Exception('Failed to load pending friends');
      }
    } catch (e) {
      debugPrint(e.toString());
      return {'sent': [], 'received': []};
    }
  }

  Future<Friend> getFriendById(String id) async {
    final response = await http.get(Uri.parse('$baseApiUri/friends/$id'));

    if (response.statusCode == 200) {
      return Friend.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load friend');
    }
  }

  Future<void> addFriend(String username) async {
    final response = await http.post(
      Uri.parse('$baseApiUri/social/friends/request'),
      headers: header,
      body: json.encode({'username': username}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add friend');
    }
  }

  Future<void> removeFriend(String username) async {
    final response = await http.delete(
        Uri.parse('$baseApiUri/social/friends/$username'),
        headers: header);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete friend');
    }
  }

  Future<List<UserSearchResult>> searchUserProfile(String username) async {
    final response = await http.get(
        Uri.parse('$baseApiUri/social/friends/search?username=$username'),
        headers: header);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      debugPrint(data.toString());
      final usersList =
          data.map((json) => UserSearchResult.fromMap(json)).toList();

      return usersList;
    } else {
      throw Exception('Failed to search user profile');
    }
  }
}
