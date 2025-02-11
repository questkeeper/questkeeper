import 'package:flutter/material.dart';

class NavRailItem extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;
  final IconData? icon;
  final Widget? leading;

  const NavRailItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
    this.icon,
    this.leading,
  });

  @override
  State<NavRailItem> createState() => _NavRailItemState();
}

class _NavRailItemState extends State<NavRailItem> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor =
        widget.isSelected ? colorScheme.primary : colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (details) => setState(() => _isHovered = true),
        onExit: (details) => setState(() => _isHovered = false),
        child: widget.isExpanded
            ? _buildExpandedItem(colorScheme, textColor)
            : Tooltip(
                message: widget.label,
                waitDuration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: TextStyle(color: textColor),
                child: _buildExpandedItem(colorScheme, textColor),
              ),
      ),
    );
  }

  Widget _buildExpandedItem(colorScheme, textColor) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: widget.onTap,
      child: Container(
        height: 40,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _isHovered
              ? colorScheme.primary.withValues(alpha: 0.1)
              : widget.isSelected
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.leading != null)
              Container(
                width: 20,
                height: 20,
                alignment:
                    widget.isExpanded ? Alignment.centerLeft : Alignment.center,
                child: widget.leading!,
              ),
            if (widget.icon != null)
              Container(
                width: 20,
                alignment:
                    widget.isExpanded ? Alignment.centerLeft : Alignment.center,
                child: Icon(
                  widget.icon,
                  size: 20,
                  color: textColor,
                ),
              ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.isExpanded ? 132 : 0, // 120 + 12 padding
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: widget.isExpanded ? 12 : 0,
                  ),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(color: textColor),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
