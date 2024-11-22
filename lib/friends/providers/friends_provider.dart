import 'dart:math';

import 'package:uuid/uuid.dart';
import 'package:faker/faker.dart';
import 'package:questkeeper/constants.dart';
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

      if (isDebug) {
        var uuid = Uuid();
        var random = Random();

        for (var i = 0; i < 20; i++) {
          friends.add(Friend(
              userId: uuid.v4(),
              username: faker.internet.userName(),
              points: random.nextInt(100000).toString(),
          ));
        }
      }

      return friends;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception("Error fetching friends: $e");
    }
  }

  Future<void> removeFriend(String username) async {
    state = const AsyncValue.loading();
    try {
      await _repository.removeFriend(username);
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
