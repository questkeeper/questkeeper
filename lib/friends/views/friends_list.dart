import 'package:flutter/material.dart';
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
        title: Text(
          'Friends',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        elevation: 0,
      ),
      body: friendsListAsyncValue.when(
        data: (friendsList) => _buildFriendsList(friendsList),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Oops! Something went wrong: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add friend functionality
        },
        child: const Icon(Icons.add),
      ),
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
                    '${friend.points} points',
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
