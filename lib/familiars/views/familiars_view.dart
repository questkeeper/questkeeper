import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:questkeeper/familiars/widgets/familiars_widget_game.dart';

class FamiliarsView extends StatelessWidget {
  const FamiliarsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.transparent,
          margin: const EdgeInsets.all(16.0),
          child: AspectRatio(
            aspectRatio: 2 / 1, // Adjust this ratio as needed
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: GameWidget(
                game: FamiliarsWidgetGame(),
                backgroundBuilder: (context) {
                  return Container(
                    height: 320,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
