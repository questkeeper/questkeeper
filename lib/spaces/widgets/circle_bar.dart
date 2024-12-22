import 'package:flutter/material.dart';

class CircleBar extends StatelessWidget {
  const CircleBar({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.all(8),
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: isActive ? 16 : 12,
      width: isActive ? 16 : 12,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.grey[350],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
