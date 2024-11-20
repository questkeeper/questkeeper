import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:questkeeper/familiars/components/characters/character_sprite_component.dart';
import 'package:questkeeper/familiars/components/characters/character_state.dart';
import 'package:questkeeper/familiars/components/characters/sprite_sheet_loader.dart';
import 'package:questkeeper/familiars/components/clock_component.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<ui.Image> loadSpriteSheet(String url) async {
  final imageProvider = CachedNetworkImageProvider(url);
  final completer = Completer<ui.Image>();
  imageProvider.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener((ImageInfo info, _) {
      if (!completer.isCompleted) completer.complete(info.image);
    }),
  );
  return completer.future;
}

enum Direction { left, right, none }

class FamiliarsWidgetGame extends FlameGame {
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

  Future<void> updateBackground(int page, String updatedBackgroundPath) async {
    if (!_isMapInitialized) return;

    final backgroundPath = updatedBackgroundPath;
    try {
      final newImage = await loadSpriteSheet(backgroundPath);
      mapComponent.sprite = Sprite(newImage);
    } catch (e) {
      debugPrint('Failed to update background: $e');
    }
  }

  Future<void> loadCharacter({String characterId = "red_panda"}) async {
    // Load JSON from Supabase/storage
    final spriteSheetJsonData = utf8.decode(await supabaseClient.storage
        .from('assets')
        .download('characters/$characterId/sprite_sheet.json'));

    // Load sprite sheet image
    final spriteSheetUrl = supabaseClient.storage.from("assets").getPublicUrl(
          'characters/$characterId/sprite_sheet.png',
        );

    // Parse and create character sprites
    final characterSprites = await SpriteSheetLoader.loadFromJson(
      spriteSheetJsonData,
      characterId,
    );

    // Create component and add to game
    final spriteComponent = CharacterSpriteComponent(
      sprites: characterSprites,
      spriteSheet: await loadSpriteSheet(spriteSheetUrl),
    );

    redPanda = spriteComponent;
    add(redPanda);

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
          await loadSpriteSheet(backgroundPath),
        ),
        size: size,
      );

      add(mapComponent);
      _isMapInitialized = true;

      await loadCharacter();
      _isCharacterInitialized = true;
      final randomYOffset = size.y / 4;
      final randomXOffset = size.x / 4;
      final randomXPlusOrMinus =
          (randomXOffset * 2) * (Random().nextBool() ? 1 : -1);
      redPanda.position =
          Vector2(randomXPlusOrMinus, (size.y - 48 - randomYOffset));

      clock = ClockComponent(
        position: Vector2(
          (size.x / 2) - 23,
          38,
        ),
        size: Vector2(128, 128), // Match your sprite size
      );

      add(clock);
    } catch (e) {
      debugPrint('Failed to load background: $e');
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
      final temp = mapComponent.width;
      mapComponent.width = mapComponent.height;
      mapComponent.height = temp;
      scale = (adjustedSize.x * 2 / mapComponent.width);
    } else {
      scale = adjustedSize.y / mapComponent.height;
    }

    mapComponent.scale = Vector2.all(scale);

    // Update red panda position based on height factor
    redPanda.position = Vector2(
      adjustedSize.x / 2,
      redPanda.position.y / 2 + adjustedSize.y / 3,
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
