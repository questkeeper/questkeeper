import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsCard extends StatefulWidget {
  const SettingsCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
    this.icon,
    this.svgIconPath,
    this.backgroundColor,
    this.iconColor,
  });

  final String title;
  final String description;
  final Function onTap;
  final IconData? icon;
  final String? svgIconPath;
  final Color? backgroundColor;
  final Color? iconColor;

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
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).iconTheme.color,
      ),
      iconColor: widget.iconColor ?? Theme.of(context).iconTheme.color,
      leading: widget.svgIconPath != null
          ? SvgPicture.asset(
              widget.svgIconPath!,
              width: 24,
              height: 24,
              colorFilter: widget.iconColor != null
                  ? ColorFilter.mode(
                      widget.iconColor!,
                      BlendMode.srcIn,
                    )
                  : null,
            )
          : widget.icon != null
              ? Icon(widget.icon)
              : null,
      title: Text(widget.title),
      subtitle: Text(widget.description),
      onTap: () {
        widget.onTap();
      },
    );
  }
}
