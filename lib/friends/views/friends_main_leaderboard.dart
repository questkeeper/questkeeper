import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/friends/providers/friends_provider.dart';
import 'package:questkeeper/friends/widgets/friend_list_tile.dart';
import 'package:questkeeper/friends/widgets/friend_request_bottom_sheet.dart';
import 'package:questkeeper/friends/widgets/friend_search.dart';
import 'package:questkeeper/friends/widgets/sort_menu.dart';
import 'package:questkeeper/shared/widgets/trophy_avatar.dart';

class FriendsList extends ConsumerStatefulWidget {
  const FriendsList({super.key});

  @override
  ConsumerState<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends ConsumerState<FriendsList> {
  var _sortSettings = SortSettings();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asyncValue = ref.watch(friendsManagerProvider);
    // final pendingRequestsAsyncValue = ref.watch(friendsRequestManagerProvider);

    if (asyncValue.isLoading || !asyncValue.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }

    if (asyncValue.hasError) {
      // TODO do something with these values
      final error = asyncValue.error!;
      final stack = asyncValue.stackTrace!;

      return const Center(
        child: Text("Failed to fetch friends list"),
      );
    }

    var unsorted = asyncValue.value!;
    var sorted = _sortSettings.sorted(unsorted.toList(growable: false));

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(LucideIcons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: FriendSearchDelegate(),
            );
          },
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: sorted.length,
                padding: const EdgeInsets.all(16),
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 16);
                },
                itemBuilder: (context, index) {
                  final friend = sorted[index];
                  const top3 = [0, 1, 2];
                  if (top3.contains(index)) {
                    return Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        FriendListTile(friend: friend),
                        Positioned(
                          left: 40,
                          child: TrophyAvatar(
                            trophyType: TrophyType.values[index],
                            radius: 30,
                          ),
                        ),
                      ],
                    );
                  }
                  return FriendListTile(friend: friend);
                },
              ),
            ),
            Container(
              color: theme.colorScheme.surfaceContainerLow,
              padding: EdgeInsets.all(20),
              child: _SortWidget(
                settings: _sortSettings,
                onChange: (settings) {
                  setState(() {
                    _sortSettings = settings;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPendingRequestsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      enableDrag: true,
      isDismissible: true,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return const FriendRequestBottomSheet();
      },
    );
  }
}

class SortSettings {
  var type = _SortType.points;
  var direction = _SortDirection.descending;

  List<Friend> sorted(List<Friend> list) {
    list.sort((first, second) {
      switch (type) {
        case _SortType.alphabetical:
          return first.username.compareTo(second.username);

        case _SortType.points:
          return second.points.compareTo(first.points);
      }
    });

    if (direction == _SortDirection.ascending) {
      list = list.reversed.toList();
    }

    return list;
  }
}

typedef OnChangeSettings = void Function(SortSettings settings);

class _SortWidget extends StatefulWidget {
  const _SortWidget({
    required this.settings,
    required this.onChange,
  });

  final SortSettings settings;
  final OnChangeSettings onChange;

  @override
  State<StatefulWidget> createState() => _SortWidgetState();
}

class _SortWidgetState extends State<_SortWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sorting type
        SortMenu(
          values: _SortType.values,
          selected: widget.settings.type,
          onSelection: (value) {
            widget.settings.type = value as _SortType;
            widget.onChange.call(widget.settings);
          },
        ),

        const SizedBox(width: 10),

        // Sorting direction
        SortMenu(
          values: _SortDirection.values,
          selected: widget.settings.direction,
          onSelection: (value) {
            widget.settings.direction = value as _SortDirection;
            widget.onChange.call(widget.settings);
          },
        ),
      ],
    );
  }
}

enum _SortType implements SortValue {
  points("Points", LucideIcons.arrow_down_1_0),
  alphabetical("Alphabetical", LucideIcons.arrow_down_a_z);

  const _SortType(this.display, this.iconData);

  @override
  final String display;

  @override
  final IconData? iconData;
}

enum _SortDirection implements SortValue {
  ascending("Ascending", LucideIcons.arrow_down_z_a),
  descending("Descending", LucideIcons.arrow_down_a_z);

  const _SortDirection(this.display, this.iconData);

  @override
  final String display;

  @override
  final IconData? iconData;
}
