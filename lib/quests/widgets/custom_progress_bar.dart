import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final BorderRadius? borderRadius;
  final Widget? label;
  final bool showPercentage;
  final TextStyle? percentageStyle;
  final bool animated;
  final Duration animationDuration;

  const CustomProgressBar({
    super.key,
    required this.progress,
    this.height = 16.0,
    this.backgroundColor,
    this.progressColor,
    this.borderRadius,
    this.label,
    this.showPercentage = false,
    this.percentageStyle,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 500),
  }) : assert(progress >= 0 && progress <= 1,
            'Progress must be between 0.0 and 1.0');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorderRadius = BorderRadius.circular(8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          label!,
          const SizedBox(height: 4),
        ],
        Stack(
          alignment: Alignment.center,
          children: [
            // Background
            Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    backgroundColor ?? theme.colorScheme.surfaceContainerHigh,
                borderRadius: borderRadius ?? defaultBorderRadius,
              ),
            ),

            // Progress
            Align(
              alignment: Alignment.centerLeft,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return animated
                      ? AnimatedContainer(
                          duration: animationDuration,
                          height: height,
                          width: constraints.maxWidth * progress,
                          decoration: BoxDecoration(
                            color: progressColor ?? theme.colorScheme.tertiary,
                            borderRadius: borderRadius ?? defaultBorderRadius,
                          ),
                        )
                      : Container(
                          height: height,
                          width: constraints.maxWidth * progress,
                          decoration: BoxDecoration(
                            color: progressColor ?? theme.colorScheme.tertiary,
                            borderRadius: borderRadius ?? defaultBorderRadius,
                          ),
                        );
                },
              ),
            ),

            // Percentage text (if enabled)
            if (showPercentage)
              Text(
                '${(progress * 100).toInt()}%',
                style: percentageStyle ??
                    theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
          ],
        ),
      ],
    );
  }
}
