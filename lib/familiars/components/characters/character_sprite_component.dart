import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:questkeeper/familiars/components/characters/character_sprites.dart';
import 'package:questkeeper/familiars/components/characters/character_state.dart';

class CharacterSpriteComponent extends SpriteAnimationComponent {
  final CharacterSprites sprites;
  late final Image spriteSheet;
  CharacterState currentState = CharacterState.idle;

  CharacterSpriteComponent({
    required this.sprites,
    required this.spriteSheet,
  }) : super(size: Vector2.all(96), anchor: Anchor.topCenter) {
    // Initialize with idle animation
    updateAnimation(spriteSheet);
  }

  void updateAnimation(Image spriteSheet) {
    final frames = sprites.animations[currentState];
    if (frames == null) return;

    try {
      final spriteAnimation = SpriteAnimation.fromFrameData(
        spriteSheet,
        SpriteAnimationData(
          loop: true,
          frames
              .map(
                (frame) => SpriteAnimationFrameData(
                  srcPosition: frame.position,
                  srcSize: frame.size,
                  stepTime: frame.duration / 650, // Convert to seconds
                ),
              )
              .toList(),
        ),
      );

      animation = spriteAnimation;
    } catch (e) {
      debugPrint('Error updating animation: $e');
    }
  }

  void setState(CharacterState newState) {
    if (currentState != newState && sprites.animations.containsKey(newState)) {
      currentState = newState;
      // Remember to call updateAnimation with the sprite sheet when changing state
      updateAnimation(spriteSheet);
    }
  }
}
