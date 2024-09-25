import 'package:questkeeper/friends/models/friend_model.dart';
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

  Future<void> addFriend(Friend friend) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addFriend(friend);
      await refreshFriends();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateFriend(Friend friend) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateFriend(friend);
      await refreshFriends();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteFriend(Friend friend) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteFriend(friend.username);
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
}
