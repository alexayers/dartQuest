


import '../../../engine/application/gameScreenOverlay.dart';
import '../../../engine/ecs/gameEntity.dart';
import '../../../engine/ecs/gameEntityRegistry.dart';
import '../../../engine/logger/logger.dart';
import '../../../engine/primitives/color.dart';
import '../../../engine/rendering/animatedSprite.dart';
import '../../../engine/rendering/renderer.dart';
import '../../../engine/utils/mathUtils.dart';
import '../../components/healthComponent.dart';

class UiOverlayScreen implements GameScreenOverlay {

  late AnimatedSprite coins;
  GameEntityRegistry gameEntityRegistry = GameEntityRegistry.instance;
  late GameEntity player;

  @override
  void init() {

    player = gameEntityRegistry.getSingleton("player");
    Map<String, List<String>> coinSprites = {};

    coinSprites["default"] = [
      "../../assets/images/ui/money1.png",
      "../../assets/images/ui/money2.png",
      "../../assets/images/ui/money3.png",
      "../../assets/images/ui/money4.png",
      "../../assets/images/ui/money5.png",
    ];

    coins = AnimatedSprite(coinSprites, "default");


  }

  @override
  void render() {
    //coins.render(10,50,32,32);

    Renderer.rect(5, Renderer.getCanvasHeight() - 60, 180, 15, Colors.black);

    HealthComponent healthComponent = player.getComponent("health") as HealthComponent;

    int healthPercent = MathUtils.calculatePercent(healthComponent.current, healthComponent.max).floor();
    int healthBarSize = MathUtils.calculateXPercentOfY(healthPercent, 180).floor();

    Renderer.rect(5, Renderer.getCanvasHeight() - 60, healthBarSize, 15, Colors.red);

  }

}
