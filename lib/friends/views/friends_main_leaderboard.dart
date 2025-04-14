import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/friends/providers/friends_provider.dart';
import 'package:questkeeper/friends/providers/friends_request_provider.dart';
import 'package:questkeeper/friends/widgets/friend_request_bottom_sheet.dart';
import 'package:questkeeper/friends/widgets/leaderboard_sort_options.dart';
import 'package:questkeeper/friends/widgets/skeletonized_friends_list.dart';
import 'package:questkeeper/friends/widgets/user_profile_view.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
    await ref.refresh(profileManagerProvider.notifier).fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asyncValue = ref.watch(friendsManagerProvider);

    return Scaffold(
      // Appbar with same bg color as the body
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        flexibleSpace: Container(
          color: theme.scaffoldBackgroundColor,
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _refreshFriendsList,
        child: Column(
          children: [
            Material(
              elevation: 1,
              child: const UserProfileView(),
            ),

            Material(
              elevation: 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SortWidget(
                          settings: _sortSettings,
                          onChange: (settings) {
                            setState(() {
                              _sortSettings = settings;
                            });
                          },
                        ),
                      ),
                      _friendRequestButton(),
                    ],
                  ),
                ),
              ),
            ),

            // Friends list
            Expanded(
              child: SkeletonizedFriendsList(
                asyncValue: asyncValue,
                sortSettings: _sortSettings,
                removeFriendHandler: _removeFriendHandler,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _friendRequestButton() {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(friendsRequestManagerProvider).when(
              data: (requests) {
                return requests.isNotEmpty &&
                        (requests['sent']!.isNotEmpty ||
                            requests['received']!.isNotEmpty)
                    ? Badge(
                        offset: const Offset(0, 2),
                        label: Text(
                          (requests['sent']!.length +
                                  requests['received']!.length)
                              .toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        child: ActionChip(
                          avatar: const Icon(LucideIcons.bell_plus),
                          label: const Text('Pending Requests'),
                          onPressed: () {
                            _showPendingRequestsBottomSheet(context);
                          },
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

  void _removeFriendHandler(Friend friend) {
    ref.read(friendsManagerProvider.notifier).removeFriend(friend.username);
    Navigator.of(context).pop(); // Close the popup menu

    SnackbarService.showSuccessSnackbar('Friend removed');
  }
}
