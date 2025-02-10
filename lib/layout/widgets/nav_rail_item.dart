import 'package:flutter/material.dart';

class NavRailItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = isSelected ? colorScheme.primary : colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: 40,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color:
                isSelected ? colorScheme.primary.withValues(alpha: 0.1) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null)
                Container(
                  width: 20,
                  height: 20,
                  alignment:
                      isExpanded ? Alignment.centerLeft : Alignment.center,
                  child: leading!,
                ),
              if (icon != null)
                Container(
                  width: 20,
                  alignment:
                      isExpanded ? Alignment.centerLeft : Alignment.center,
                  child: Icon(
                    icon,
                    size: 20,
                    color: textColor,
                  ),
                ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isExpanded ? 132 : 0, // 120 + 12 padding
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isExpanded ? 12 : 0,
                    ),
                    Expanded(
                      child: Text(
                        label,
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
      ),
    );
  }
}
