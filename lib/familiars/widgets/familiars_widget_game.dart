import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:questkeeper/familiars/components/characters/character_sprite_component.dart';
import 'package:questkeeper/familiars/components/characters/character_state.dart';
import 'package:questkeeper/familiars/components/characters/sprite_sheet_loader.dart';
import 'package:questkeeper/familiars/components/clock_component.dart';

enum Direction { left, right, none }

/// Game class for the FamiliarsWidget
/// This class is responsible for managing the game state and rendering the game
/// It uses FlameGame as the base class
/// The game consists of a background map and a character sprite
/// The character sprite can be animated and moved around the map
/// Takes in [backgroundPath] as a parameter to set the background map on first load
/// The game is designed to be used as a widget
class FamiliarsWidgetGame extends FlameGame with SingleGameInstance {
  var _dtSum = 0.0;
  final fixedRate = 1 / 10; // 10 updates per second

  @override
  void updateTree(double dt) {
    _dtSum += dt;
    if (_dtSum > fixedRate) {
      super.updateTree(fixedRate);
      _dtSum -= fixedRate;
    }
  }

  /// Constructor for the FamiliarsWidgetGame
  FamiliarsWidgetGame({required this.backgroundPath});

  final String backgroundPath;
  late CharacterSpriteComponent redPanda;
  late SpriteComponent mapComponent;
  bool _isMapInitialized = false, _isCharacterInitialized = false;
  final supabaseClient = Supabase.instance.client;

  double heightFactor = 1.0;
  bool isAnimatingEntry = false;
  Vector2? targetPosition;
  Direction entryDirection = Direction.none;

  late ClockComponent clock;

  double idleTime = 0;
  final double idleDuration = 5;

  Future<void> updateBackground(String backgroundPath) async {
    if (!_isMapInitialized) return;

    try {
      final imagePath = backgroundPath.split("assets/").last;
      mapComponent.sprite = Sprite(
        await images.load(imagePath),
      );
    } catch (e) {
      debugPrint('Failed to update background: $e');
    }
  }

  Future<void> loadCharacter({String characterId = "red_panda"}) async {
    final spriteSheetJsonData = await images.bundle.loadString(
      "assets/images/characters/$characterId/sprite_sheet.json",
    );

    // Load sprite sheet image
    final spriteSheetUrl = "characters/$characterId/sprite_sheet.png";

    // Parse and create character sprites
    final characterSprites = await SpriteSheetLoader.loadFromJson(
      spriteSheetJsonData,
      characterId,
    );

    // Create component and add to game
    final spriteComponent = CharacterSpriteComponent(
      sprites: characterSprites,
      spriteSheet: await images.load(spriteSheetUrl),
    );

    redPanda = spriteComponent;
    await add(redPanda);

    // Load animations
    redPanda.animation!;
    spriteComponent.setState(CharacterState.sleep);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    try {
      mapComponent = SpriteComponent(
        sprite: Sprite(
          await images.load(backgroundPath),
        ),
        size: size,
      );

      await add(mapComponent);
      _isMapInitialized = true;

      clock = ClockComponent(
        position: Vector2(
          (size.x / 2) - 23,
          38,
        ),
        size: Vector2(128, 128), // Match your sprite size
      );

      await add(clock);
    } catch (e) {
      debugPrint('Failed to load background: $e');
    }

    try {
      await loadCharacter();
      _isCharacterInitialized = true;

      // Calculate position based on the game's viewport size
      final characterPosition = Vector2(
        (size.x / 2) + (redPanda.width / 2), // Center horizontally
        size.y * 0.75, // Position at 75% of screen height (adjust as needed)
      );

      // Adjust for character's size/anchor point if necessary
      characterPosition.sub(Vector2(
        redPanda.size.x / 2, // Center the character sprite horizontally
        redPanda.size.y / 2, // Center the character sprite vertically
      ));

      redPanda.position = characterPosition;

      // Optionally, add boundary checking
      redPanda.position.clamp(
        Vector2.zero() + redPanda.size / 2,
        size - redPanda.size / 2,
      );
    } catch (e) {
      debugPrint('Failed to load character: $e');
    }
  }

  // Add method to update height factor
  void updateHeightFactor(double factor) {
    heightFactor = factor;
    onGameResize(size);
  }

  bool shouldScaleToSquare(Vector2 size) {
    return size.x == size.y;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    if (!_isMapInitialized || !_isCharacterInitialized) return;

    // Apply height factor to the game size
    final adjustedSize = Vector2(size.x, size.y * heightFactor);

    late final double scale;
    if (shouldScaleToSquare(adjustedSize)) {
      final width = mapComponent.width;
      mapComponent.width = mapComponent.height;
      mapComponent.height = width;
      scale = (adjustedSize.x * 2 / mapComponent.width);
    } else {
      scale = adjustedSize.y / mapComponent.height;
    }

    mapComponent.scale = Vector2.all(scale);

    // Update red panda position based on height factor
    redPanda.position = Vector2(
      adjustedSize.x / 2,
      (redPanda.position.y / 2) + (adjustedSize.y / 3),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_isMapInitialized) return;

    // Handle entry animation
    if (isAnimatingEntry && targetPosition != null) {
      final direction = entryDirection == Direction.left ? 1 : -1;
      redPanda.position.x += 300 * dt * direction;

      if ((direction > 0 && redPanda.position.x >= targetPosition!.x) ||
          (direction < 0 && redPanda.position.x <= targetPosition!.x)) {
        redPanda.position.x = targetPosition!.x;
        redPanda.setState(CharacterState.idle);
        isAnimatingEntry = false;
        targetPosition = null;
        entryDirection = Direction.none;
      }
    }

    idleTime += dt;
    if (idleTime >= idleDuration) {
      idleTime = 0;
      startSleepTransition();
    }
  }

  void startSleepTransition() {
    redPanda.animation?.loop = false;
    redPanda.animationTicker?.onComplete = () {
      redPanda.setState(CharacterState.sleep);
    };
  }

  void wakeUp() {
    // Reverse the transition animation and then play idle animation
    redPanda.setState(CharacterState.idle);
    redPanda.animationTicker?.onComplete = () {
      redPanda.setState(CharacterState.idle);
    };
    idleTime = 0;
  }

  void animateEntry(Direction direction) {
    if (isAnimatingEntry) return;

    isAnimatingEntry = true;
    entryDirection = direction;

    // Set initial position off-screen
    final startX =
        direction == Direction.left ? -redPanda.width : size.x + redPanda.width;
    final targetX = size.x / 2;

    redPanda.position.x = startX;
    targetPosition = Vector2(targetX, redPanda.position.y);

    // Set appropriate scale based on direction
    redPanda.scale = Vector2(
      direction == Direction.left ? 1 : -1,
      1,
    );

    // Start run animation
    redPanda.setState(CharacterState.movement);
  }
}
