import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/friends/repositories/friend_repository.dart';
import 'package:questkeeper/shared/widgets/avatar_widget.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/shared/widgets/trophy_avatar.dart';

class FriendListTile extends StatelessWidget {
  final Friend friend;
  final int position;
  final Function(Friend friend) onRemove;
  static const top3 = {
    "1": TrophyType.gold,
    "2": TrophyType.silver,
    "3": TrophyType.bronze
  };

  const FriendListTile(
      {super.key,
      required this.friend,
      required this.position,
      required this.onRemove});

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
                trophyType: top3[position.toString()]!,
              ),
            ),
          PopupMenuButton(
            icon: Icon(LucideIcons.ellipsis_vertical),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(LucideIcons.user),
                    title: Text('View Profile'),
                    onTap: () => SnackbarService.showInfoSnackbar(
                        'View Profile not implemented yet'),
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(LucideIcons.redo),
                    title: Text('Nudge'),
                    onTap: () async {
                      try {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }

                        final response = await FriendRepository()
                            .nudgeFriend(friend.username);

                        if (context.mounted) {
                          if (response.success) {
                            SnackbarService.showSuccessSnackbar(
                                response.message);
                          } else {
                            SnackbarService.showErrorSnackbar(response.message);
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          SnackbarService.showErrorSnackbar(e.toString());
                        }
                      }
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(
                      LucideIcons.user_minus,
                      color: Colors.redAccent,
                    ),
                    title: Text('Remove Friend'),
                    onTap: () {
                      onRemove(friend);
                    },
                  ),
                ),
              ];
            },
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
