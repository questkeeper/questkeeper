import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/familiars/widgets/familiars_widget_game.dart';

class AnimatedGameContainer extends StatelessWidget {
  final FamiliarsWidgetGame game;
  final double heightFactor;
  final bool shouldTextShow;

  const AnimatedGameContainer({
    super.key,
    required this.game,
    required this.heightFactor,
    this.shouldTextShow = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: heightFactor > 0.3
          ? MediaQuery.sizeOf(context).width *
              (3 / 4) // Height based on aspect ratio
          : 60, // Height for minimized state
      constraints: BoxConstraints(
        maxHeight: 400,
      ),
      child: Stack(
        children: [
          // Game Widget with opacity animation
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: heightFactor > 0.3 ? 1.0 : 0.0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
              child: GameWidget(game: game),
            ),
          ),
          // Text with opacity animation
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: heightFactor <= 0.3 ? 1.0 : 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16.0),
              ),
              alignment: Alignment.center,
              child: shouldTextShow
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.arrow_down, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Pull down to expand',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
