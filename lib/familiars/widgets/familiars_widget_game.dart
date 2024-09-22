import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class FamiliarsWidgetGame extends FlameGame {
  late SpriteAnimationComponent redPanda;
  late SpriteAnimation idleAnimation;
  late SpriteAnimation sleepAnimation;
  late SpriteAnimation sleepTransitionAnimation;
  late TiledMap map;

  double idleTime = 0;
  final double idleDuration = 5;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final component = await TiledComponent.load('main_map.tmx',
        Vector2.all(32)); // Clip this so it doesn't leave parent container
    add(component);

    final spriteSheet = await images.load('red_panda_sprites.png');

    // Create the idle animation (first row)
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
        texturePosition: Vector2(0, 32 * 5), // Start at the fifth row
      ),
    );

    // Create the second animation (second row)
    sleepAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(32, 32),
        stepTime: 0.15,
        loop: true,
        texturePosition: Vector2(0, 32 * 6), // Start at the sixth row
      ),
    );

    redPanda = SpriteAnimationComponent(
      animation: idleAnimation,
      size: Vector2.all(96),
    );

    redPanda.position = size / 2 - redPanda.size / 2;
    add(redPanda);
  }

  // @override
  // void update(double dt) {
  //   super.update(dt);

  //   idleTime += dt;
  //   if (idleTime >= idleDuration) {
  //     idleTime = 0;
  //     switchToSleepAnimation();
  //   }

  //   // Keep the second animation only, don't switch back
  //   if (redPanda.animation == sleepAnimation) {
  //     idleTime = 0;
  //   }
  // }

  // void switchToSleepAnimation() {
  //   if (redPanda.animation == idleAnimation) {
  //     redPanda.animation = sleepTransitionAnimation;
  //     redPanda.animation = sleepAnimation;
  //   } else {
  //     redPanda.animation = idleAnimation;
  //   }
  // }

  @override
  void update(double dt) {
    super.update(dt);

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
    redPanda.animation = idleAnimation;
    idleTime = 0;
  }
}
