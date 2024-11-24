import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/shared/widgets/avatar_widget.dart';
import 'package:questkeeper/shared/widgets/trophy_avatar.dart';

class FriendListTile extends StatelessWidget {
  final Friend friend;
  final int position;
  static const top3 = {
    "1": TrophyType.gold,
    "2": TrophyType.silver,
    "3": TrophyType.bronze
  };

  const FriendListTile(
      {super.key, required this.friend, required this.position});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: position.isEven
          ? Theme.of(context).colorScheme.surfaceContainerLow
          : Theme.of(context).colorScheme.surfaceContainerHigh,
      leading: AvatarWidget(
        seed: friend.userId,
        radius: 20,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (top3.containsKey(position.toString()))
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TrophyAvatar(
                radius: 20,
                trophyType: top3[position.toString()]!,
              ),
            ),
          IconButton(
            icon: const Icon(LucideIcons.ellipsis_vertical),
            onPressed: () {},
          ),
        ],
      ),
      title: Text(
        friend.username,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        '${friend.points} points',
      ),
    );
  }
}
