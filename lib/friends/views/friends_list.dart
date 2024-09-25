import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/friends/providers/friends_provider.dart';

class FriendsList extends ConsumerStatefulWidget {
  const FriendsList({super.key});

  @override
  ConsumerState<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends ConsumerState<FriendsList> {
  @override
  Widget build(BuildContext context) {
    final friendsListAsyncValue = ref.watch(friendsManagerProvider);

    return Scaffold(
      appBar: AppBar(
        // large app bar and offset
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
      body: friendsListAsyncValue.when(
        data: (friendsList) => Column(
          children: [
            _podiumBuilder(
              friendsList.length > 3 ? friendsList.sublist(0, 3) : friendsList,
            ),
            const SizedBox(height: 16),
            Expanded(
                child: _buildFriendsList(
              friendsList.length > 3 ? friendsList.sublist(3) : [],
            )),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Oops! Something went wrong: $error'),
        ),
      ),
    );
  }

  Widget _podiumBuilder(List<Friend> friendsList) {
    friendsList = friendsList +
        [
          Friend(
            userId: '1',
            username: 'Manage Friends',
            points: '0',
          ),
          Friend(userId: '2', username: 'Add Friends', points: '999'),
        ];

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

  Widget _buildFriendsList(List<Friend> friendsList) {
    friendsList = [
          Friend(
              userId: '1',
              username: 'Manage Friends',
              points: "Click to manage")
        ] +
        friendsList;
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
              return _FriendCard(friend: friend);
            },
          );
  }
}

class _FriendCard extends StatelessWidget {
  final Friend friend;

  const _FriendCard({required this.friend});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                friend.username[0].toUpperCase(),
                style: TextStyle(fontSize: 24, color: Colors.blue.shade800),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.username,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${friend.points} ${int.tryParse(friend.points) == null ? "" : "points"}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // TODO: Implement more options functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
