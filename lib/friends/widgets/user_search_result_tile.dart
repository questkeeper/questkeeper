import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/friends/models/user_search_model.dart';
import 'package:questkeeper/friends/providers/friends_provider.dart';
import 'package:questkeeper/friends/providers/friends_request_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSearchResultTile extends ConsumerWidget {
  const UserSearchResultTile({
    super.key,
    required this.user,
  });

  final UserSearchResult user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the ref to the request state
    final friendRequestManager =
        ref.watch(friendsRequestManagerProvider.notifier);
    final friendsManager = ref.watch(friendsManagerProvider.notifier);
    final isPending = user.status == 'pending';
    final isFriend = user.status == 'friend';
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).focusColor,
      key: key,
      child: Column(
        children: [
          ListTile(
            title: Text(user.username),
            subtitle:
                Text(!isFriend && !isPending ? 'Not friends' : user.status!),
            trailing: ElevatedButton.icon(
              onPressed: () {
                if (isFriend) {
                  friendsManager.removeFriend(user.username);
                } else if (isPending) {
                  friendRequestManager.rejectRequest(user);
                } else {
                  friendRequestManager.acceptRequest(user);
                }
              },
              icon: Icon(
                isFriend
                    ? LucideIcons.x
                    : isPending
                        ? LucideIcons.x
                        : LucideIcons.plus,
                size: 16,
              ),
              label: Text(
                isFriend
                    ? 'Remove'
                    : isPending
                        ? 'Reject'
                        : 'Accept',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
