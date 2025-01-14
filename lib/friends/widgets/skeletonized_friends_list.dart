import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/friends/providers/friends_provider.dart';
import 'package:questkeeper/friends/widgets/friend_list_tile.dart';
import 'package:questkeeper/friends/widgets/leaderboard_sort_options.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizedFriendsList extends StatelessWidget {
  SkeletonizedFriendsList({
    super.key,
    required this.asyncValue,
    required this.sortSettings,
    required this.refreshFriendsList,
    required this.removeFriendHandler,
  });

  final AsyncValue<List<Friend>> asyncValue;
  final SortSettings sortSettings;
  final Future<void> Function() refreshFriendsList;
  final void Function(Friend) removeFriendHandler;

  final skeletonList = List.generate(
    10,
    (index) => FriendListTile(
      friend: Friend(
        userId: 'loading',
        username: 'Loading User',
        points: 1000,
      ),
      position: index + 1,
      onRemove: (_) {},
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: asyncValue.isLoading || !asyncValue.hasValue,
      child: Consumer(
        builder: (context, ref, child) {
          final asyncValue = ref.watch(friendsManagerProvider);

          return asyncValue.when(
            error: (error, stack) {
              Sentry.captureException(
                error,
                stackTrace: stack,
              );

              return const Center(
                child: Text("Failed to fetch friends list"),
              );
            },
            loading: () => ListView.separated(
              itemCount: skeletonList.length,
              padding: const EdgeInsets.all(16),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, index) => skeletonList[index],
            ),
            data: (friends) {
              final currentUserProfile =
                  ref.watch(profileManagerProvider).value;
              final friendsList = [
                ...friends,
                Friend(
                  userId: 'current_user',
                  username: currentUserProfile?.username ?? 'You',
                  points: currentUserProfile?.points ?? 0,
                )
              ];

              final sorted =
                  sortSettings.sorted(friendsList.toList(growable: false));

              return RefreshIndicator(
                onRefresh: refreshFriendsList,
                child: ListView.separated(
                  itemCount: sorted.length + 1,
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index == sorted.length) {
                      return const SizedBox(
                        height: kBottomNavigationBarHeight + 32,
                      );
                    }

                    final friend = sorted[index];
                    return FriendListTile(
                      friend: friend,
                      position: index + 1,
                      onRemove: removeFriendHandler,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
