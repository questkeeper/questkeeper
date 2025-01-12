import 'package:flame/game.dart';
import 'package:flutter/material.dart';
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
          : 0, // Height for minimized state
      constraints: BoxConstraints(
        maxHeight: 400,
      ),
      child: Stack(
        children: [
          // Game Widget with opacity animation
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: heightFactor > 0.3 ? 1.0 : 0.0,
            child: GameWidget(game: game),
          ),
        ],
      ),
    );
  }
}
