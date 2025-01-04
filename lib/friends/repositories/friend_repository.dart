import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/friends/models/user_search_model.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:questkeeper/shared/utils/http_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class FriendRepository {
  final HttpService _httpService = HttpService();

  Future<List<Friend>> fetchFriends() async {
    try {
      final response = await _httpService.get('/social/friends');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Friend.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load friends');
      }
    } catch (error) {
      Sentry.captureException(error);
      throw Exception('Failed to load friends');
    }
  }

  Future<Map<String, List<UserSearchResult>>> fetchPendingFriends() async {
    try {
      final response = await _httpService.get('/social/friends/pending');

      if (response.statusCode == 200) {
        List<UserSearchResult> sentRequests = (response.data['sent'] as List)
            .map((json) => UserSearchResult.fromMap(json).copyWith(sent: true))
            .toList();

        List<UserSearchResult> receivedRequests =
            (response.data['received'] as List)
                .map((json) => UserSearchResult.fromMap(json))
                .toList();

        return {'sent': sentRequests, 'received': receivedRequests};
      } else {
        throw Exception('Failed to load pending friends');
      }
    } catch (error) {
      Sentry.captureException(error);
      return {'sent': [], 'received': []};
    }
  }

  Future<Friend> getFriendById(String id) async {
    try {
      final response = await _httpService.get('/friends/$id');

      if (response.statusCode == 200) {
        return Friend.fromMap(response.data);
      } else {
        throw Exception('Failed to load friend');
      }
    } catch (error) {
      Sentry.captureException(error);
      throw Exception('Failed to load friend');
    }
  }

  Future<void> requestFriend(String username) async {
    try {
      final response = await _httpService.post(
        '/social/friends/request',
        data: {'username': username},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add friend');
      }
    } catch (error) {
      Sentry.captureException(error);
      throw Exception('Failed to add friend');
    }
  }

  Future<void> acceptFriendRequest(String username) async {
    try {
      final response = await _httpService.post(
        '/social/friends/accept',
        data: {'username': username},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to accept friend request');
      }
    } catch (error) {
      Sentry.captureException(error);
      throw Exception('Failed to accept friend request');
    }
  }

  Future<void> rejectFriendRequest(String username) async {
    try {
      final response = await _httpService.post(
        '/social/friends/reject',
        data: {'username': username},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to reject friend request');
      }
    } catch (error) {
      Sentry.captureException(error);
      throw Exception('Failed to reject friend request');
    }
  }

  Future<void> removeFriend(String username) async {
    try {
      final response = await _httpService.delete('/social/friends/$username');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete friend');
      }
    } catch (error) {
      Sentry.captureException(error);
      throw Exception('Failed to delete friend');
    }
  }

  Future<List<UserSearchResult>> searchUserProfile(String username) async {
    try {
      final response = await _httpService.get(
        '/social/friends/search',
        queryParameters: {'username': username},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => UserSearchResult.fromMap(json)).toList();
      } else {
        throw Exception('Failed to search user profile');
      }
    } catch (error) {
      Sentry.captureException(error);
      throw Exception('Failed to search user profile');
    }
  }

  Future<ReturnModel> nudgeFriend(String username) async {
    try {
      final response = await _httpService.post(
        '/social/friends/nudge',
        data: {'username': username},
      );

      return ReturnModel(
        message: response.data['message'],
        success: response.statusCode == 200,
        data: response.data,
      );
    } catch (error) {
      Sentry.captureException(error);
      throw Exception('Failed to nudge friend');
    }
  }
}
