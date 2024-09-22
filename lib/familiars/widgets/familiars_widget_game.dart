import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class FamiliarsWidgetGame extends FlameGame with TapDetector {
  late SpriteAnimationComponent redPanda;
  late SpriteAnimation idleAnimation;
  late SpriteAnimation sleepAnimation;
  late SpriteAnimation sleepTransitionAnimation;
  late SpriteAnimation attackAnimation;
  late SpriteAnimation jumpToAnimation;
  TiledComponent? mapComponent;

  double idleTime = 0;
  final double idleDuration = 5;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    mapComponent = await TiledComponent.load('main_map.tmx', Vector2.all(32));
    add(mapComponent!);

    final spriteSheet = await images.load('red_panda_sprites.png');

    idleAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2.all(32),
        stepTime: 0.15,
        loop: true,
      ),
    );

    sleepTransitionAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2.all(32),
        stepTime: 0.15,
        loop: false,
        texturePosition: Vector2(0, 32 * 5),
      ),
    );

    sleepAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(32, 32),
        stepTime: 0.15,
        loop: true,
        texturePosition: Vector2(0, 32 * 6),
      ),
    );

    jumpToAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(32, 32),
        stepTime: 0.15,
        loop: false,
        texturePosition: Vector2(0, 32 * 2),
      ),
    );

    attackAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(32, 32),
        stepTime: 0.15,
        loop: false,
        texturePosition: Vector2(0, 32 * 3),
      ),
    );

    redPanda = SpriteAnimationComponent(
      animation: idleAnimation,
      size: Vector2.all(96),
      // Center the red panda in the game
      position: Vector2(size.x / 2, size.y / 2 - 64),
    );

    add(redPanda);

    camera.viewfinder.anchor = Anchor.topLeft;
  }

  bool shouldScaleToSquare(Vector2 size) {
    return size.x == size.y;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    if (mapComponent == null) {
      return;
    }

    late final double scale;
    if (shouldScaleToSquare(size)) {
      // Swap width and height for calculations when rotated
      final temp = mapComponent!.width;
      mapComponent!.width = mapComponent!.height;
      mapComponent!.height = temp;

      scale = (size.x * 2 / mapComponent!.width);
      redPanda.position = Vector2(size.x / 2, size.y / 2 - 64);
      redPanda.scale = Vector2.all(1.5);
    } else {
      scale = size.y / mapComponent!.height;
      redPanda.position = Vector2(size.x / 2, size.y / 2 - 64);
      redPanda.scale = Vector2.all(1);
    }

    mapComponent!.scale = Vector2.all(scale);

    // Position the red panda
    redPanda.position = Vector2(
      size.x / 2,
      size.y / 2 - 64,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (mapComponent == null) {
      return; // Skip update if map is not loaded yet
    }

    idleTime += dt;
    if (idleTime >= idleDuration && redPanda.animation == idleAnimation) {
      idleTime = 0;
      startSleepTransition();
    }
  }

  void startSleepTransition() {
    redPanda.animation = sleepTransitionAnimation;
    redPanda.animationTicker?.onComplete = () {
      redPanda.animation = sleepAnimation;
    };
  }

  void wakeUp() {
    // Reverse the transition animation and then play idle animation
    redPanda.animation = sleepTransitionAnimation.reversed();
    redPanda.animationTicker?.onComplete = () {
      redPanda.animation = idleAnimation;
    };
    idleTime = 0;
  }

  @override
  void onTapDown(TapDownInfo info) {
    // Check if the tap position intersects with the red panda's position and size
    final tapPosition = info.eventPosition.widget;
    if (redPanda.containsPoint(tapPosition)) {
      wakeUp(); // Trigger wake up animation
      return;
    }

    if (redPanda.animation == jumpToAnimation) {
      return; // Skip if red panda is already jumping
    }

    final distance = tapPosition - redPanda.position;
    bool attack = false;
    final currentScale = redPanda.scale.x;
    if (distance.x > 0) {
      attack = distance.x < 140;
      redPanda.scale = Vector2(currentScale.abs(), currentScale.abs());
    } else {
      attack = distance.x > -20;
      redPanda.scale = Vector2(-currentScale.abs(), currentScale.abs());
    }

    final distanceX = distance.x;

    if (attack) {
      redPanda.animation = attackAnimation;
      // Move redpanda to the right directly after jump at frame 3
      redPanda.animationTicker!.onFrame = (frame) {
        if (frame == 3) {
          redPanda.position.x += 3;
        }
        if (frame == 4) {
          redPanda.position.x += 7;
        }
      };

      redPanda.animationTicker?.onComplete = () {
        redPanda.animation = idleAnimation;
      };

      return;
    } else {
      redPanda.animation = jumpToAnimation;

      if (distanceX < 0) {
        redPanda.position.add(Vector2(0, 10));
      }

      const int totalFrames = 8;
      final moveXPerFrame = distanceX / totalFrames;
      // final moveYPerFrame = distanceY / totalFrames;

      redPanda.animationTicker!.onFrame = (frame) {
        if (frame >= 1 && frame <= 6) {
          redPanda.position.add(Vector2(moveXPerFrame, 0));
        }

        if (frame == 8) {
          redPanda.position.add(Vector2(0, 10));
        }
      };

      redPanda.animationTicker?.onComplete = () {
        redPanda.animation = idleAnimation;
      };
    }

    return;
  }
}
