import 'package:flame/game.dart';
import 'package:questkeeper/familiars/components/characters/character_state.dart';

class CharacterSprites {
  final String characterId;
  final Map<CharacterState, List<Frame>> animations;
  final Vector2 spriteSize;

  CharacterSprites({
    required this.characterId,
    required this.animations,
    required this.spriteSize,
  });
}

class Frame {
  final Vector2 position;
  final Vector2 size;
  final int duration;

  Frame({
    required this.position,
    required this.size,
    required this.duration,
  });
}
