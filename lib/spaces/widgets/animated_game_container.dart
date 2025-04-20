import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/familiars/widgets/familiars_widget_game.dart';
import 'package:questkeeper/spaces/providers/game_provider.dart';

class AnimatedGameContainer extends ConsumerWidget {
  final FamiliarsWidgetGame game;
  final double heightFactor;
  final bool shouldTextShow;
  final String ownerId;

  const AnimatedGameContainer({
    super.key,
    required this.game,
    required this.heightFactor,
    required this.ownerId,
    this.shouldTextShow = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameManager = ref.watch(gameManagerProvider);
    final canAttach = gameManager.canAttach(ownerId);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: heightFactor > 0.3
          ? MediaQuery.sizeOf(context).width *
              (3 / 4) // Height based on aspect ratio
          : 0, // Height for minimized state
      constraints: const BoxConstraints(
        maxHeight: 400,
      ),
      child: Stack(
        children: [
          // Game Widget with opacity animation
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: heightFactor > 0.3 ? 1.0 : 0.0,
            child: canAttach 
                ? GameWidget(game: game)
                : const SizedBox(), // Show nothing if we can't attach
          ),
        ],
      ),
    );
  }
}
