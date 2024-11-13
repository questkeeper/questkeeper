import 'dart:convert';

import 'package:flame/game.dart';
import 'package:questkeeper/familiars/components/characters/character_sprites.dart';
import 'package:questkeeper/familiars/components/characters/character_state.dart';

class SpriteSheetLoader {
  // Load and parse sprite sheet data from JSON
  static Future<CharacterSprites> loadFromJson(
      String jsonString, String characterId) async {
    final data = json.decode(jsonString);
    final frames = data['frames'] as Map<String, dynamic>;
    final meta = data['meta'] as Map<String, dynamic>;

    // Get sprite size from first frame
    final firstFrame = frames.values.first as Map<String, dynamic>;
    final spriteSize = Vector2(
      firstFrame['sourceSize']['w'].toDouble(),
      firstFrame['sourceSize']['h'].toDouble(),
    );

    // Map to store animations by state
    final animations = <CharacterState, List<Frame>>{};

    // Get available layers/animations from meta
    final layers = meta['layers'] as List<dynamic>;

    // Process each layer/animation type
    for (final layer in layers) {
      final layerName = (layer['name'] as String).toLowerCase();
      final state = _mapLayerToState(layerName);

      if (state != null) {
        final stateFrames = frames.entries
            .where((entry) => entry.key.toLowerCase().contains("($layerName)"))
            .map((entry) {
          final frameData = entry.value as Map<String, dynamic>;
          final frameInfo = frameData['frame'] as Map<String, dynamic>;

          return Frame(
            position: Vector2(
              frameInfo['x'].toDouble(),
              frameInfo['y'].toDouble(),
            ),
            size: Vector2(
              frameInfo['w'].toDouble(),
              frameInfo['h'].toDouble(),
            ),
            duration: frameData['duration'] as int,
          );
        }).toList();

        if (stateFrames.isNotEmpty) {
          animations[state] = stateFrames;
        }
      }
    }

    return CharacterSprites(
      characterId: characterId,
      animations: animations,
      spriteSize: spriteSize,
    );
  }

  // Helper method to map layer names to normalized states
  static CharacterState? _mapLayerToState(String layerName) {
    switch (layerName) {
      case 'idle':
      case 'idle2':
        return CharacterState.idle;
      case 'movement':
        return CharacterState.movement;
      case 'sleep':
        return CharacterState.sleep;
      case 'death':
        return CharacterState.death;
      default:
        return null; // Skip unmapped states
    }
  }
}
