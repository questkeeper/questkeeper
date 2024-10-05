import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/friends/providers/friends_request_provider.dart';
import 'package:questkeeper/friends/widgets/user_search_result_tile.dart';

class FriendRequestBottomSheet extends ConsumerWidget {
  const FriendRequestBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingRequestsAsyncValue = ref.watch(friendsRequestManagerProvider);
    final pendingRequests = pendingRequestsAsyncValue.asData?.value ?? {};
    final sentRequests = pendingRequests['sent'] ?? [];
    final receivedRequests = pendingRequests['received'] ?? [];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  'Friend Requests',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            if (sentRequests.isNotEmpty) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Sent (${sentRequests.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final request = sentRequests[index];
                    return UserSearchResultTile(
                      user: request,
                      query: '',
                    );
                  },
                  childCount: sentRequests.length,
                ),
              ),
            ],
            if (receivedRequests.isNotEmpty) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Received (${receivedRequests.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final request = receivedRequests[index];
                    return UserSearchResultTile(
                      user: request,
                      query: '',
                    );
                  },
                  childCount: receivedRequests.length,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
