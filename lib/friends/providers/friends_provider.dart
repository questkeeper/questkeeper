import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/friends/models/user_search_model.dart';
import 'package:questkeeper/friends/repositories/friend_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_provider.g.dart';

@riverpod
class FriendsManager extends _$FriendsManager {
  final FriendRepository _repository;

  FriendsManager() : _repository = FriendRepository();

  @override
  FutureOr<List<Friend>> build() async {
    return fetchFriends();
  }

  Future<List<Friend>> fetchFriends() async {
    try {
      var friends = await _repository.fetchFriends();
      return friends;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception("Error fetching friends: $e");
    }
  }

  Future<void> addFriend(String username) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addFriend(username);
      await refreshFriends();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> removeFriend(Friend friend) async {
    state = const AsyncValue.loading();
    try {
      await _repository.removeFriend(friend.username);
      await refreshFriends();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshFriends() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await ref.refresh(friendsManagerProvider.future));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<Map<String, List<UserSearchResult>>> pendingRequests() async {
    try {
      var pending = await _repository.fetchPendingFriends();
      return pending;
    } catch (e) {
      throw Exception("Error fetching pending friends: $e");
    }
  }
}
