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
    this.sent, // Checks if I sent the request or received it
  });

  final UserSearchResult user;
  final bool? sent;

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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (isFriend) {
                        friendsManager.removeFriend(user.username);
                      } else if (isPending) {
                        friendRequestManager.rejectRequest(user);
                      } else {
                        if (sent == true) {
                          friendRequestManager.acceptRequest(user);
                        } else {
                          friendRequestManager.sendRequest(user.username);
                        }
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
                      switch (isFriend) {
                        true => 'Remove',
                        false => isPending
                            ? sent == true
                                ? 'Reject'
                                : 'Cancel'
                            : 'Send',
                      },
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: sent == true
                        ? const SizedBox()
                        : FilledButton.icon(
                            onPressed: () {
                              if (isPending) {
                                friendRequestManager.acceptRequest(user);
                              } else {
                                friendRequestManager.sendRequest(user.username);
                              }
                            },
                            label: Text(
                              isPending ? 'Accept' : 'Request',
                            ),
                            icon: const Icon(LucideIcons.check),
                          ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
