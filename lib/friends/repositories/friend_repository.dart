import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:questkeeper/constants.dart';
import 'package:questkeeper/friends/models/friend_model.dart';
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

  // Future<Friend> getFriendById(String id) async {
  //   final response = await http.get(Uri.parse('$apiUrl/friends/$id'));

  //   if (response.statusCode == 200) {
  //     return Friend.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to load friend');
  //   }
  // }

  Future<void> addFriend(Friend friend) async {
    final response = await http.post(
      Uri.parse('$baseApiUri/social/friends'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(friend.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add friend');
    }
  }

  Future<void> updateFriend(Friend friend) async {
    final response = await http.put(
      Uri.parse('$baseApiUri/social/friends/${friend.userId}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(friend.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update friend');
    }
  }

  Future<void> deleteFriend(String id) async {
    final response =
        await http.delete(Uri.parse('$baseApiUri/social/friends/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete friend');
    }
  }
}
