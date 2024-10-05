import 'package:questkeeper/friends/models/user_search_model.dart';
import 'package:questkeeper/friends/providers/friends_provider.dart';
import 'package:questkeeper/friends/repositories/friend_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_request_provider.g.dart';

@riverpod
class FriendsRequestManager extends _$FriendsRequestManager {
  final FriendRepository _repository;

  FriendsRequestManager() : _repository = FriendRepository();

  @override
  FutureOr<Map<String, List<UserSearchResult>>> build() async {
    return fetchPendingRequests();
  }

  Future<Map<String, List<UserSearchResult>>> fetchPendingRequests() async {
    try {
      var pendingRequests = await _repository.fetchPendingFriends();
      return pendingRequests;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception("Error fetching pending requests: $e");
    }
  }

  Future<void> acceptRequest(UserSearchResult request) async {
    state = const AsyncValue.loading();
    try {
      await _repository.acceptFriendRequest(request.username);
      _refreshFriendsAndRequests();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> rejectRequest(UserSearchResult request) async {
    state = const AsyncValue.loading();
    try {
      await _repository.rejectFriendRequest(request.username);
      await refreshPendingRequests();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshPendingRequests() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(
          await ref.refresh(friendsRequestManagerProvider.future));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> sendRequest(String username) async {
    state = const AsyncValue.loading();
    try {
      await _repository.requestFriend(username);
      await refreshPendingRequests();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> removeRequest(UserSearchResult request) async {
    state = const AsyncValue.loading();
    try {
      await _repository.removeFriend(request.username);
      await refreshPendingRequests();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void _refreshFriendsAndRequests() {
    ref.invalidate(friendsManagerProvider);
    ref.invalidate(friendsRequestManagerProvider);
    ref.read(friendsManagerProvider.notifier).refreshFriends();
    ref.read(friendsRequestManagerProvider.notifier).refreshPendingRequests();
  }
}
