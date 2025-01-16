import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/friends/models/user_search_model.dart';
import 'package:questkeeper/friends/providers/friends_provider.dart';
import 'package:questkeeper/friends/providers/friends_request_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/friends/widgets/friend_search.dart';

class UserSearchResultTile extends ConsumerWidget {
  const UserSearchResultTile({
    super.key,
    required this.user,
    required this.query,
  });

  final UserSearchResult user;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendRequestManager =
        ref.watch(friendsRequestManagerProvider.notifier);
    final friendsManager = ref.watch(friendsManagerProvider.notifier);

    final isPending = user.status == 'pending';
    final isFriend = user.status == 'friend';
    final sent = user.sent;

    void reloadSearch() {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const FriendSearchView()),
        );
      }
    }

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
            subtitle: Text(_getSubtitleText(isFriend, isPending, sent)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: _buildActionButtons(
                  isFriend: isFriend,
                  isPending: isPending,
                  sent: sent,
                  onRemoveFriend: () {
                    friendsManager.removeFriend(user.username);
                    reloadSearch();
                  },
                  onRejectRequest: () {
                    friendRequestManager.rejectRequest(user);
                    reloadSearch();
                  },
                  onAcceptRequest: () {
                    friendRequestManager.acceptRequest(user);
                    reloadSearch();
                  },
                  onSendRequest: () {
                    friendRequestManager.sendRequest(user.username);
                    reloadSearch();
                  }),
            ),
          )
        ],
      ),
    );
  }

  String _getSubtitleText(bool isFriend, bool isPending, bool? sent) {
    if (isFriend) return user.status ?? 'Friends';
    if (isPending) {
      return sent == true ? 'Request sent' : 'Request received';
    }
    return 'Not friends';
  }

  List<Widget> _buildActionButtons({
    required bool isFriend,
    required bool isPending,
    required bool? sent,
    required VoidCallback onRemoveFriend,
    required VoidCallback onRejectRequest,
    required VoidCallback onAcceptRequest,
    required VoidCallback onSendRequest,
  }) {
    if (isFriend) {
      return [
        _buildButton(
          icon: LucideIcons.x,
          label: 'Remove',
          onPressed: onRemoveFriend,
        ),
      ];
    }

    if (isPending) {
      if (sent == true) {
        return [
          _buildButton(
            icon: LucideIcons.x,
            label: 'Cancel',
            onPressed: onRejectRequest,
          ),
        ];
      } else {
        return [
          _buildButton(
            icon: LucideIcons.x,
            label: 'Reject',
            onPressed: onRejectRequest,
          ),
          const SizedBox(width: 8),
          _buildButton(
            icon: LucideIcons.check,
            label: 'Accept',
            onPressed: onAcceptRequest,
            isFilled: true,
          ),
        ];
      }
    }

    // Not friends and no pending request
    return [
      _buildButton(
        icon: LucideIcons.plus,
        label: 'Send Request',
        onPressed: onSendRequest,
        isFilled: true,
      ),
    ];
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isFilled = false,
  }) {
    final button = isFilled
        ? FilledButton.icon as Widget Function({
            required VoidCallback onPressed,
            required Widget icon,
            required Widget label,
          })
        : ElevatedButton.icon as Widget Function({
            required VoidCallback onPressed,
            required Widget icon,
            required Widget label,
          });

    return button(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
