import 'package:flutter/material.dart';

class NavRailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;

  const NavRailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.primaryContainer : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                if (isExpanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.8),
                        fontWeight: isSelected ? FontWeight.w600 : null,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
