import 'package:flutter/material.dart';

class SettingsSwitchCard extends StatelessWidget {
  const SettingsSwitchCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.iconColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color? iconColor;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor,
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
