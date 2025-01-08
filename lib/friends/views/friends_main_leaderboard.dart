import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/friends/providers/friends_provider.dart';
import 'package:questkeeper/friends/providers/friends_request_provider.dart';
import 'package:questkeeper/friends/widgets/friend_list_tile.dart';
import 'package:questkeeper/friends/widgets/friend_request_bottom_sheet.dart';
import 'package:questkeeper/friends/widgets/friend_search.dart';
import 'package:questkeeper/friends/widgets/sort_menu.dart';
import 'package:questkeeper/profile/model/profile_model.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/shared/widgets/avatar_widget.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FriendsList extends ConsumerStatefulWidget {
  const FriendsList({super.key});

  @override
  ConsumerState<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends ConsumerState<FriendsList> {
  var _sortSettings = SortSettings();

  Future<void> _refreshFriendsList() async {
    // ignore: unused_result
    await ref.refresh(friendsManagerProvider.future);
    // ignore: unused_result
    ref.refresh(friendsRequestManagerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asyncValue = ref.watch(friendsManagerProvider);

    // Create a skeleton list for loading state
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

    Widget mainContent;
    if (asyncValue.hasError) {
      final error = asyncValue.error!;
      final stack = asyncValue.stackTrace!;

      Sentry.captureException(
        error,
        stackTrace: stack,
      );

      mainContent = const Center(
        child: Text("Failed to fetch friends list"),
      );
    } else {
      final currentUserProfile = ref.watch(profileManagerProvider).value;
      List<Friend> friendsList = asyncValue.hasValue ? asyncValue.value! : [];
      friendsList.add(
        // Add current user profile
        Friend(
          userId: 'current_user',
          username: currentUserProfile?.username ?? 'Current User',
          points: currentUserProfile?.points ?? 0,
        ),
      );
      var sorted = asyncValue.hasValue
          ? _sortSettings.sorted(friendsList.toList(growable: false))
          : [];

      mainContent = RefreshIndicator(
        onRefresh: _refreshFriendsList,
        child: ListView.separated(
          itemCount: asyncValue.hasValue ? sorted.length : skeletonList.length,
          padding: const EdgeInsets.all(16),
          separatorBuilder: (context, index) {
            return const SizedBox(height: 16);
          },
          itemBuilder: (context, index) {
            if (!asyncValue.hasValue) {
              return skeletonList[index];
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
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(LucideIcons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: FriendSearchDelegate(),
            );
          },
        ),
        body: Column(
          children: [
            Material(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Consumer(
                  builder: (context, ref, _) {
                    final asyncValue = ref.watch(profileManagerProvider);
                    return Skeletonizer(
                      enabled:
                          asyncValue is AsyncLoading || !asyncValue.hasValue,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              asyncValue is AsyncData
                                  ? AvatarWidget(
                                      seed:
                                          (asyncValue.value as Profile).user_id)
                                  : const CircleAvatar(radius: 50),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        asyncValue is AsyncData
                                            ? (asyncValue.value as Profile)
                                                .username
                                            : 'Username Loading',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      if (asyncValue is AsyncData &&
                                          (asyncValue.value as Profile).isPro ==
                                              true)
                                        const Text('PRO',
                                            style: TextStyle(
                                                color: Colors.greenAccent))
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    asyncValue is AsyncData
                                        ? '${(asyncValue.value as Profile).points} points'
                                        : '0 points',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    asyncValue is AsyncData
                                        ? 'Account since ${(asyncValue.value as Profile).created_at.split("T")[0]}'
                                        : 'Account since 2024-01-01',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.6),
                                        ),
                                  ),
                                  Text(
                                    "Nudge Limit: 3",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.6),
                                        ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Skeletonizer(
                enabled: asyncValue.isLoading || !asyncValue.hasValue,
                child: mainContent,
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                return ref.watch(friendsRequestManagerProvider).when(
                      data: (requests) {
                        return requests.isNotEmpty &&
                                (requests['sent']!.isNotEmpty ||
                                    requests['received']!.isNotEmpty)
                            ? Material(
                                elevation: 4,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 600),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _showPendingRequestsBottomSheet(
                                            context);
                                      },
                                      icon: const Icon(LucideIcons.bell_plus),
                                      label: const Text('Pending Requests'),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox();
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) {
                        Sentry.captureException(
                          error,
                          stackTrace: stack,
                        );

                        return const Text('Failed to fetch pending requests');
                      },
                    );
              },
            ),
            Container(
              color: theme.colorScheme.surfaceContainerLow,
              padding: EdgeInsets.all(20),
              child: _SortWidget(
                settings: _sortSettings,
                onChange: (settings) {
                  setState(() {
                    _sortSettings = settings;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPendingRequestsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      enableDrag: true,
      isDismissible: true,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return const FriendRequestBottomSheet(
          key: Key('friend_request_bottom_sheet'),
        );
      },
    );
  }

  void removeFriendHandler(Friend friend) {
    ref.read(friendsManagerProvider.notifier).removeFriend(friend.username);
    Navigator.of(context).pop(); // Close the popup menu

    SnackbarService.showSuccessSnackbar('Friend removed');
  }
}

class SortSettings {
  var type = _SortType.points;
  var direction = _SortDirection.descending;

  List<Friend> sorted(List<Friend> list) {
    list.sort((first, second) {
      switch (type) {
        case _SortType.alphabetical:
          return first.username.compareTo(second.username);

        case _SortType.points:
          return second.points.compareTo(first.points);
      }
    });

    if (direction == _SortDirection.ascending) {
      list = list.reversed.toList();
    }

    return list;
  }
}

typedef OnChangeSettings = void Function(SortSettings settings);

class _SortWidget extends StatefulWidget {
  const _SortWidget({
    required this.settings,
    required this.onChange,
  });

  final SortSettings settings;
  final OnChangeSettings onChange;

  @override
  State<StatefulWidget> createState() => _SortWidgetState();
}

class _SortWidgetState extends State<_SortWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sorting type
        SortMenu(
          values: _SortType.values,
          selected: widget.settings.type,
          onSelection: (value) {
            widget.settings.type = value as _SortType;
            widget.onChange.call(widget.settings);
          },
        ),

        const SizedBox(width: 10),

        // Sorting direction
        SortMenu(
          values: _SortDirection.values,
          selected: widget.settings.direction,
          onSelection: (value) {
            widget.settings.direction = value as _SortDirection;
            widget.onChange.call(widget.settings);
          },
        ),
      ],
    );
  }
}

enum _SortType implements SortValue {
  points("Points", LucideIcons.arrow_down_1_0),
  alphabetical("Alphabetical", LucideIcons.arrow_down_a_z);

  const _SortType(this.display, this.iconData);

  @override
  final String display;

  @override
  final IconData? iconData;
}

enum _SortDirection implements SortValue {
  ascending("Ascending", LucideIcons.arrow_down_z_a),
  descending("Descending", LucideIcons.arrow_down_a_z);

  const _SortDirection(this.display, this.iconData);

  @override
  final String display;

  @override
  final IconData? iconData;
}
