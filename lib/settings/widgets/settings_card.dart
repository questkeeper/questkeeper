import 'package:flutter/material.dart';

class SettingsCard extends StatefulWidget {
  const SettingsCard(
      {super.key,
      required this.title,
      required this.description,
      required this.icon,
      required this.onTap,
      this.backgroundColor});

  final String title;
  final String description;
  final IconData icon;
  final Function onTap;
  final Color? backgroundColor;

  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: widget.backgroundColor,
      enableFeedback: true,
      visualDensity: VisualDensity.comfortable,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      iconColor: Theme.of(context).iconTheme.color,
      leading: Icon(widget.icon),
      title: Text(widget.title),
      subtitle: Text(widget.description),
      onTap: () {
        widget.onTap();
      },
    );
  }
}
