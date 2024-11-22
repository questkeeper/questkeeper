import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/shared/widgets/avatar_widget.dart';

class FriendListTile extends StatelessWidget {
  final Friend friend;

  const FriendListTile({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Theme.of(context).cardColor,
      leading: AvatarWidget(
        seed: friend.userId,
        radius: 30,
      ),
      trailing: IconButton(
        icon: const Icon(LucideIcons.ellipsis_vertical),
        onPressed: () {},
      ),
      title: Text(
        friend.username,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        '${friend.points} points',
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
