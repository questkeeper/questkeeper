import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/friends/models/user_search_model.dart';
import 'package:questkeeper/friends/repositories/friend_repository.dart';

class UserSearchResultTile extends StatelessWidget {
  const UserSearchResultTile({
    super.key,
    required this.user,
    required this.context,
  });

  final UserSearchResult user;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final FriendRepository repository = FriendRepository();
    final isPending = user.status == 'pending';
    final isFriend = user.status == 'friend';
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).focusColor,
      child: ListTile(
        title: Text(user.username),
        subtitle: Text(!isFriend && !isPending ? 'Not friends' : user.status!),
        trailing: isFriend
            ? IconButton(
                icon: const Icon(LucideIcons.check),
                onPressed: () {},
              )
            : isPending
                ? IconButton(
                    icon: const Icon(LucideIcons.x),
                    onPressed: () {
                      repository.removeFriend(user.username);
                    },
                  )
                : IconButton(
                    icon: const Icon(LucideIcons.plus),
                    onPressed: () {
                      repository.addFriend(user.username);
                    },
                  ),
      ),
    );
  }
}
