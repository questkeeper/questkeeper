import 'package:flutter/material.dart';
import 'package:questkeeper/friends/models/friend_model.dart';

class FriendListTile extends StatelessWidget {
  final Friend friend;

  const FriendListTile({super.key, required this.friend});

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
