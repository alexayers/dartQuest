


import '../../../engine/application/game_screen_overlay.dart';
import '../../../engine/ecs/game_entity.dart';
import '../../../engine/ecs/game_entity_registry.dart';
import '../../../engine/primitives/color.dart';
import '../../../engine/rendering/animated_sprite.dart';
import '../../../engine/rendering/rayCaster/world_map.dart';
import '../../../engine/rendering/renderer.dart';

class UiOverlayScreen implements GameScreenOverlay {

  late AnimatedSprite coins;
  GameEntityRegistry gameEntityRegistry = GameEntityRegistry.instance;
  late GameEntity player;
  final WorldMap _worldMap = WorldMap.instance;

  @override
  void init() {




  }

  @override
  void render() {
    //coins.render(10,50,32,32);

    if (!_worldMap.worldLoaded) {
      return;
    }

    Renderer.rect(5, Renderer.getCanvasHeight() - 60, 180, 15, Colors.black);

    /*
    HealthComponent healthComponent = player.getComponent("health") as HealthComponent;

    int healthPercent = MathUtils.calculatePercent(healthComponent.current, healthComponent.max).floor();
    int healthBarSize = MathUtils.calculateXPercentOfY(healthPercent, 180).floor();

    Renderer.rect(5, Renderer.getCanvasHeight() - 60, healthBarSize, 15, Colors.red);

     */

  }

}
