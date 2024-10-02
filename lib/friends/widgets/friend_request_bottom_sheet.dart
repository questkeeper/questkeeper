import 'package:flutter/material.dart';
import 'package:questkeeper/friends/models/user_search_model.dart';
import 'package:questkeeper/friends/widgets/user_search_result_tile.dart';

class FriendRequestBottomSheet extends StatelessWidget {
  const FriendRequestBottomSheet({
    super.key,
    required this.sentRequests,
    required this.receivedRequests,
  });

  final List<UserSearchResult> sentRequests;
  final List<UserSearchResult> receivedRequests;

  @override
  Widget build(BuildContext context) {
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
