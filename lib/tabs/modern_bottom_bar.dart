import 'package:flutter/material.dart';

class ModernBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<ModernBottomBarItem> items;
  final Widget? leadingAction;
  final Widget? trailingAction;
  final double maxWidth;

  const ModernBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.leadingAction,
    this.trailingAction,
    this.maxWidth = 600,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingAction != null) ...[
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 48, minHeight: 48),
              child: leadingAction!,
            ),
            const SizedBox(width: 8),
          ],

          // Main navigation bar
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isSelected = currentIndex == index;

                      return Expanded(
                        child: InkWell(
                          onTap: () => onTap(index),
                          borderRadius: BorderRadius.circular(28),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            child: Column(
                              children: [
                                if (item.icon != null) ...[
                                  Icon(
                                    item.icon,
                                    size: 20,
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected
                                        ? colorScheme.onPrimaryContainer
                                        : colorScheme.onSurface,
                                  ),
                                  child: Text(
                                    item.label,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                // Animate it to show the selection

                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInToLinear,
                                  height: 4,
                                  width: 4,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colorScheme.primary
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),

          // // Trailing action (contextual FAB)
          if (trailingAction != null) ...[
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 48, minHeight: 48),
              child: trailingAction!,
            ),
          ],
        ],
      ),
    );
  }
}

// Helper widget for action buttons
class NavActionButton extends StatelessWidget {
  final bool isEmpty;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? tooltip;
  final bool? isColoredPrimary;

  const NavActionButton({
    super.key,
    this.onPressed,
    this.icon,
    this.tooltip,
    this.isEmpty = false,
    this.isColoredPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isEmpty) {
      return SizedBox.fromSize(
        size: const Size(40, 40),
      );
    }

    return IconButton.filled(
      visualDensity: VisualDensity.comfortable,
      style: ButtonStyle(
        iconSize: WidgetStateProperty.all(24),
        backgroundColor: WidgetStateProperty.all(
          isColoredPrimary == true
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerLow,
        ),
        iconColor: WidgetStateProperty.all(
          colorScheme.primary,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: isColoredPrimary == true
            ? colorScheme.primary
            : Theme.of(context).iconTheme.color?.withValues(alpha: 0.7),
      ),
    );
  }
}

class ModernBottomBarItem {
  final IconData? icon;
  final String label;

  const ModernBottomBarItem({
    this.icon,
    required this.label,
  });
}
