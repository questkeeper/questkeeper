import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/friends/providers/friends_request_provider.dart';
import 'package:questkeeper/friends/widgets/user_search_result_tile.dart';

class FriendRequestBottomSheet extends ConsumerWidget {
  const FriendRequestBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingRequestsAsyncValue = ref.watch(friendsRequestManagerProvider);
    final pendingRequests = pendingRequestsAsyncValue.asData?.value ?? {};
    final sentRequests = pendingRequests['sent'] ?? [];
    final receivedRequests = pendingRequests['received'] ?? [];

    return Column(
      children: [
        sentRequests.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text('Sent Requests (${sentRequests.length})',
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
              )
            : const SizedBox.shrink(),
        ListView.builder(
          shrinkWrap: true,
          itemCount: sentRequests.length,
          itemBuilder: (context, index) {
            final request = sentRequests[index];
            return UserSearchResultTile(user: request);
          },
        ),
        receivedRequests.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text('Received Requests (${receivedRequests.length})',
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
              )
            : const SizedBox.shrink(),
        ListView.builder(
          shrinkWrap: true,
          itemCount: receivedRequests.length,
          itemBuilder: (context, index) {
            final request = receivedRequests[index];
            return UserSearchResultTile(user: request);
          },
        ),
      ],
    );
  }
}
