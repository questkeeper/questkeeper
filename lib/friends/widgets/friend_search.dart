import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/friends/models/user_search_model.dart';
import 'package:questkeeper/friends/repositories/friend_repository.dart';
import 'package:questkeeper/friends/widgets/user_search_result_tile.dart';

class FriendSearchView extends StatefulWidget {
  const FriendSearchView({super.key});

  @override
  State<FriendSearchView> createState() => _FriendSearchViewState();
}

class _FriendSearchViewState extends State<FriendSearchView> {
  final FriendRepository _repository = FriendRepository();
  Timer? _debounce;
  String query = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<UserSearchResult>> _debouncedSearch(String query) async {
    _debounce?.cancel();
    final completer = Completer<List<UserSearchResult>>();

    _debounce = Timer(const Duration(milliseconds: 300), () async {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Filter or add friends',
              prefixIcon: const Icon(LucideIcons.search),
              suffixIcon: query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(LucideIcons.x),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => query = '');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) => setState(() => query = value),
          ),
        ),
        Expanded(
          child: query.isEmpty
              ? const Center(child: Text('Search for friends'))
              : FutureBuilder<List<UserSearchResult>>(
                  future: _debouncedSearch(query),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No results found'));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final friend = snapshot.data![index];
                        return UserSearchResultTile(user: friend, query: query);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
