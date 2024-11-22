import 'package:flutter/material.dart';

/// Defines a value used by [SortMenu].
class SortValue {
  SortValue({
    required this.display,
    this.iconData,
  });

  /// Display text that is shown to the user.
  final String display;

  /// [IconData] that represents this value.
  final IconData? iconData;
}

/// Callback used when a [SortValue] was selected in [SortMenu].
typedef OnSelection = void Function(SortValue value);

/// Allows the user to select a series of values after selecting a [FilterChip].
class SortMenu extends StatefulWidget {
  const SortMenu({
    super.key,
    required this.values,
    required this.selected,
    required this.onSelection,
  });

  /// List of all visible values.
  final List<SortValue> values;

  /// Currently selected value.
  final SortValue selected;

  /// Callback for when the user selects a value.
  final OnSelection onSelection;

  @override
  State<StatefulWidget> createState() => _SortMenuState();
}

class _SortMenuState extends State<SortMenu> {
  /// Used to combine focus of both [MenuAnchor] and [FilterChip].
  final _focus = FocusNode();

  @override void dispose() {
    super.dispose();
    _focus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      childFocusNode: _focus,
      menuChildren: widget.values.map((value) {
        return MenuItemButton(
          child: _buildValue(context, value),
          onPressed: () {
            // Remove focus so that the MenuAnchor will be closed.
            _focus.unfocus();

            widget.onSelection.call(value);
          },
        );
      }).toList(),

      builder: (context, controller, child) {
        return FilterChip(
          focusNode: _focus,
          label: _buildValue(context, widget.selected),
          onSelected: (_) {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }

  Widget _buildValue(BuildContext context, SortValue value) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          value.iconData,
          size: 20,
          color: theme.colorScheme.outline,
        ),
        const SizedBox(width: 6),
        Text(value.display),
      ],
    );
  }
}