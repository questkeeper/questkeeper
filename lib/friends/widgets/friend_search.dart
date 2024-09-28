import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/friends/models/user_search_model.dart';
import 'package:questkeeper/friends/repositories/friend_repository.dart';

class FriendSearchDelegate extends SearchDelegate {
  final FriendRepository _repository = FriendRepository();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<UserSearchResult>>(
      future: _repository.searchUserProfile(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found'));
        } else {
          debugPrint('Results found: ${snapshot.data!.length}');
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final friend = snapshot.data![index];
              return userSearchResultTile(friend, context);
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Search suggestions'),
    );
  }

  @override
  String get searchFieldLabel => 'Filter or add friends';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        toolbarHeight: 100,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
    );
  }

// Get context
  Widget userSearchResultTile(UserSearchResult user, BuildContext context) {
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
                      _repository.removeFriend(user.username);
                    },
                  )
                : IconButton(
                    icon: const Icon(LucideIcons.plus),
                    onPressed: () {
                      _repository.addFriend(user.username);
                    },
                  ),
      ),
    );
  }
}
