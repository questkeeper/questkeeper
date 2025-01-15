import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/friends/widgets/sort_menu.dart';

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

class SortWidget extends StatefulWidget {
  const SortWidget({
    super.key,
    required this.settings,
    required this.onChange,
  });

  final SortSettings settings;
  final OnChangeSettings onChange;

  @override
  State<StatefulWidget> createState() => SortWidgetState();
}

class SortWidgetState extends State<SortWidget> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
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

          const SizedBox(width: 10),
        ],
      ),
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
