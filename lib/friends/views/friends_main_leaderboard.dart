import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/friends/providers/friends_provider.dart';
import 'package:questkeeper/friends/providers/friends_request_provider.dart';
import 'package:questkeeper/friends/widgets/friend_list_tile.dart';
import 'package:questkeeper/friends/widgets/friend_request_bottom_sheet.dart';
import 'package:questkeeper/friends/widgets/friend_search.dart';

class FriendsList extends ConsumerStatefulWidget {
  const FriendsList({super.key});

  @override
  ConsumerState<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends ConsumerState<FriendsList> {
  void _showPendingRequestsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const FriendRequestBottomSheet();
      },
    );
  }

  Widget _buildFriendsList(List<Friend> friendsList) {
    return friendsList.isEmpty
        ? Center(
            child: Text(
              'No friends yet. Add some!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: friendsList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final friend = friendsList[index];
              return FriendListTile(friend: friend);
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    final friendsListAsyncValue = ref.watch(friendsManagerProvider);
    final pendingRequestsAsyncValue = ref.watch(friendsRequestManagerProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          'Friends',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(LucideIcons.user_plus),
              iconSize: 32,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: friendsListAsyncValue.when(
              data: (friendsList) {
                return Column(
                  children: [
                    _podiumBuilder(
                      friendsList.length > 3
                          ? friendsList.sublist(0, 3)
                          : friendsList,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildFriendsList(
                        friendsList.length > 3 ? friendsList.sublist(3) : [],
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => const Center(
                child: Text('Failed to fetch friends list.'),
              ),
            ),
          ),
          pendingRequestsAsyncValue.when(
            data: (pendingRequests) =>
                // Get total length of both sent and received requests
                (pendingRequests['sent']!.length +
                            pendingRequests['received']!.length) >
                        0
                    ? TextButton.icon(
                        onPressed: () =>
                            _showPendingRequestsBottomSheet(context),
                        icon: const Icon(LucideIcons.user_plus),
                        label: Text(
                            "Pending Requests (${pendingRequests['sent']!.length + pendingRequests['received']!.length})"),
                      )
                    : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Filter or add friends',
                prefixIcon: Icon(LucideIcons.search),
              ),
              onSubmitted: (query) {
                showSearch(
                  context: context,
                  delegate: FriendSearchDelegate(),
                  query: query,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _podiumBuilder(List<Friend> friendsList) {
    if (friendsList.length > 1) {
      final temp = friendsList[0];
      friendsList[0] = friendsList[1];
      friendsList[1] = temp;
    }

    return friendsList.isEmpty
        ? const SizedBox()
        : Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < friendsList.length; i++)
                Column(
                  children: [
                    Container(
                      // border
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: i == 1 ? Colors.amber : Colors.green,
                          width: i == 1 ? 4 : 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: CircleAvatar(
                        radius: i == 1 ? 75 : 50,
                        child: Text(
                          friendsList[i].username[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: i == 1 ? 48 : 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${friendsList[i].points} points',
                      style: TextStyle(
                        fontSize: i == 1 ? 16 : 12,
                      ),
                    ),
                  ],
                ),
            ],
          );
  }
}
