import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class FamiliarsWidgetGame extends FlameGame {
  late SpriteAnimationComponent redPanda;
  late SpriteAnimation idleAnimation;
  late SpriteAnimation sleepAnimation;
  late SpriteAnimation sleepTransitionAnimation;
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

    redPanda = SpriteAnimationComponent(
      animation: idleAnimation,
      size: Vector2.all(96),
      // Center the red panda in the game
      position: Vector2(size.x / 2, size.y / 2 - 64),
    );

    add(redPanda);

    camera.viewfinder.anchor = Anchor.topLeft;
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);

    // Check if the map is loaded
    if (mapComponent == null) {
      return; // Skip resizing if map is not loaded yet
    }

    if (mapComponent != null) {
      // Resize the map to fit the screen width
      final scale = canvasSize.x / mapComponent!.width;
      mapComponent!.scale = Vector2.all(scale);
    }

    // Position the red panda
    redPanda.position = Vector2(
      canvasSize.x / 2,
      canvasSize.y - redPanda.height / 2,
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
    redPanda.animation = idleAnimation.reversed();
    idleTime = 0;
  }
}
