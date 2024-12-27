import 'dart:convert';
import 'dart:ui' show Image, Rect;

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Image, Rect;

class SingleSpriteAnimation extends FlameGame {
  late SpriteAnimationComponent spriteAnimationComponent;
  final String animalType;

  // Pass in animal type as a parameter
  SingleSpriteAnimation({required this.animalType});

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // Make sure to await super.onLoad()

    final spriteSheet =
        await images.load('characters/$animalType/sprite_sheet.png');
    final jsonData = json.decode(await images.bundle
        .loadString('assets/images/characters/$animalType/sprite_sheet.json'));

    // Create sprite animation from Aseprite data
    // TODO: Make this not hardcoded
    final animationRow =
        _extractFrames(jsonData, spriteSheet, 'Red Panda Sprite Sheet (Sleep)');

    // Create a SpriteAnimation from the frames
    final sleepAnimation = SpriteAnimation.spriteList(
      animationRow,
      stepTime: 0.125, // Duration per frame
    );

    // Add the animation to the game
    spriteAnimationComponent = SpriteAnimationComponent(
      animation: sleepAnimation,
      size: Vector2(128, 128), // Adjust as needed
      position: size / 2 - Vector2(64, 64),
    );

    add(spriteAnimationComponent);

    spriteAnimationComponent.position = size / 2 - Vector2(64, 64);

    // Align vertically in the center
    spriteAnimationComponent.position.y =
        size.y / 2 - spriteAnimationComponent.size.y / 2 - 64;
  }

  List<Sprite> _extractFrames(Map<String, dynamic> jsonData, Image spriteSheet,
      String animationPrefix) {
    final List<Sprite> frames = [];
    for (final frameName in jsonData['frames'].keys) {
      if (frameName.startsWith(animationPrefix)) {
        final frameData = jsonData['frames'][frameName]['frame'];
        final rect = Rect.fromLTWH(
          frameData['x'].toDouble(),
          frameData['y'].toDouble(),
          frameData['w'].toDouble(),
          frameData['h'].toDouble(),
        );
        frames.add(Sprite(spriteSheet,
            srcPosition: Vector2(rect.left, rect.top),
            srcSize: Vector2(rect.width, rect.height)));
      }
    }
    return frames;
  }
}

class SingleSpriteAnimationContainer extends StatelessWidget {
  const SingleSpriteAnimationContainer(
      {super.key, this.height = 64, this.animalType = 'red_panda'});
  final String animalType;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: GameWidget(
        game: SingleSpriteAnimation(
          animalType: animalType,
        ),
        backgroundBuilder: (BuildContext context) {
          return Container(
            color: Theme.of(context).colorScheme.surface,
          );
        },
      ),
    );
  }
}
