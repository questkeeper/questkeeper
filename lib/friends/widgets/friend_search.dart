import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/friends/models/user_search_model.dart';
import 'package:questkeeper/friends/repositories/friend_repository.dart';
import 'package:questkeeper/friends/widgets/user_search_result_tile.dart';

class FriendSearchDelegate extends SearchDelegate {
  final FriendRepository _repository = FriendRepository();
  Timer? _debounce;

  FriendSearchDelegate({
    String? initialQuery,
  }) {
    query = initialQuery ?? "";
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(LucideIcons.x),
        onPressed: () {
          query = '';
          _debounce?.cancel(); // Cancel ongoing debounce
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(LucideIcons.arrow_left),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Future<List<UserSearchResult>> _debouncedSearch(String query) async {
    _debounce?.cancel(); // Cancel any existing debounce
    final completer = Completer<List<UserSearchResult>>();

    _debounce = Timer(const Duration(milliseconds: 200), () async {
      try {
        final results = await _repository.searchUserProfile(query);
        completer.complete(results);
      } catch (e) {
        completer.completeError(e);
      }
    });

    return completer.future;
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<UserSearchResult>>(
      future: _debouncedSearch(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final friend = snapshot.data![index];
              return UserSearchResultTile(user: friend, query: query);
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      return buildResults(context); // Automatically show results
    }
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
        toolbarHeight: 90,
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

  @override
  void dispose() {
    _debounce?.cancel(); // Clean up debounce timer
    super.dispose();
  }
}
