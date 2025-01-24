import 'package:flutter/material.dart';

class SettingsSwitchTile extends StatefulWidget {
  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.isEnabled,
    this.description = "",
    this.icon,
    this.backgroundColor,
    this.iconColor,
  });

  final String title;
  final Function(bool value) onTap;
  final bool isEnabled;
  final String description;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  State<SettingsSwitchTile> createState() => _SettingsSwitchTileState();
}

class _SettingsSwitchTileState extends State<SettingsSwitchTile> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      tileColor: widget.backgroundColor,
      enableFeedback: true,
      visualDensity: VisualDensity.comfortable,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(widget.title),
      subtitle: Text(widget.description),
      value: widget.isEnabled,
      onChanged: widget.onTap,
    );
  }
}
