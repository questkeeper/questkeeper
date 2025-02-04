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
            color: isSelected ? colorScheme.primary.withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                alignment: isExpanded ? Alignment.centerLeft : Alignment.center,
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
                        overflow: TextOverflow.clip,
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
