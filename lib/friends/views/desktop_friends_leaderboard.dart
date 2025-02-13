import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/friends/providers/friends_provider.dart';
import 'package:questkeeper/friends/providers/friends_request_provider.dart';
import 'package:questkeeper/friends/widgets/leaderboard_sort_options.dart';
import 'package:questkeeper/friends/widgets/skeletonized_friends_list.dart';
import 'package:questkeeper/friends/widgets/user_profile_view.dart';
import 'package:questkeeper/friends/widgets/user_search_result_tile.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/shared/providers/window_size_provider.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class DesktopFriendsLeaderboard extends ConsumerStatefulWidget {
  const DesktopFriendsLeaderboard({super.key});

  @override
  ConsumerState<DesktopFriendsLeaderboard> createState() =>
      _DesktopFriendsLeaderboardState();
}

class _DesktopFriendsLeaderboardState
    extends ConsumerState<DesktopFriendsLeaderboard> {
  var _sortSettings = SortSettings();
  Friend? _selectedFriend;

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
    final isCompact = ref.watch(isCompactProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          children: [
            // Left panel - User Profile and Sort Options
            Container(
              width: isCompact ? 280 : 320,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Text(
                          'Your Profile',
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 16),
                      UserProfileView(),
                    ],
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Actions',
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        _friendRequestButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main content area - Friends List
            Expanded(
              child: Material(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Leaderboard',
                                style: theme.textTheme.headlineSmall,
                              ),
                              const Spacer(),
                              SortWidget(
                                settings: _sortSettings,
                                onChange: (settings) {
                                  setState(() {
                                    _sortSettings = settings;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: Row(
                          children: [
                            // Friends List
                            Expanded(
                              flex: 3,
                              child: RefreshIndicator.adaptive(
                                onRefresh: _refreshFriendsList,
                                child: SkeletonizedFriendsList(
                                  asyncValue: asyncValue,
                                  sortSettings: _sortSettings,
                                  removeFriendHandler: _removeFriendHandler,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                final hasRequests = requests.isNotEmpty &&
                    (requests['sent']!.isNotEmpty ||
                        requests['received']!.isNotEmpty);

                if (!hasRequests) return const SizedBox();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Friend Requests',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (requests['received']!.isNotEmpty)
                      Card(
                        child: ExpansionTile(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          collapsedShape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          leading: const Icon(LucideIcons.inbox),
                          title: Row(
                            children: [
                              const Text('Received'),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  requests['received']!.length.toString(),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            for (final request in requests['received']!)
                              UserSearchResultTile(
                                user: request,
                                query: '',
                              ),
                          ],
                        ),
                      ),
                    if (requests['sent']!.isNotEmpty) ...[
                      if (requests['received']!.isNotEmpty)
                        const SizedBox(height: 8),
                      Card(
                        child: ExpansionTile(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          collapsedShape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          leading: const Icon(LucideIcons.send),
                          title: Row(
                            children: [
                              const Text('Sent'),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  requests['sent']!.length.toString(),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            for (final request in requests['sent']!)
                              UserSearchResultTile(
                                user: request,
                                query: '',
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
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

  void _removeFriendHandler(Friend friend) {
    ref.read(friendsManagerProvider.notifier).removeFriend(friend.username);
    Navigator.of(context).pop(); // Close the popup menu

    setState(() {
      if (_selectedFriend?.username == friend.username) {
        _selectedFriend = null;
      }
    });

    SnackbarService.showSuccessSnackbar('Friend removed');
  }
}
