import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
class SortMenu extends StatelessWidget {
  const SortMenu({
    super.key,
    required this.values,
    required this.selected,
    required this.onSelection,
  });

  final List<SortValue> values;
  final SortValue selected;
  final OnSelection onSelection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Create custom button that looks like a FilterChip
    Widget customButton(BuildContext context) {
      return Chip(
        label: _buildValue(context, selected),
        color: WidgetStateProperty.all(theme.colorScheme.surface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2<SortValue>(
        customButton: customButton(context),
        items: values.map((value) {
          return DropdownMenuItem<SortValue>(
            value: value,
            child: _buildValue(context, value),
          );
        }).toList(),
        value: selected,
        onChanged: (value) {
          if (value != null) {
            onSelection(value);
          }
        },
        // Customize dropdown styling
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: theme.colorScheme.surface,
          ),
        ),
      ),
    );
  }

  Widget _buildValue(BuildContext context, SortValue value) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (value.iconData != null) ...[
          Icon(
            value.iconData,
            size: 20,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(width: 6),
        ],
        Text(value.display),
      ],
    );
  }
}
