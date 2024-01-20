

import '../../engine/ecs/components/rendering/animated_sprite_component.dart';
import '../../engine/ecs/components/item_component.dart';
import '../../engine/ecs/components/position_component.dart';
import '../../engine/ecs/game_entity_builder.dart';
import '../../engine/rendering/animated_sprite.dart';
import '../../engine/rendering/sprite.dart';
import '../../engine/rendering/spritesheet.dart';

class Flower {

  static create(SpriteSheet spriteSheet) {
    Map<String, List<String>> animation = {};
    animation["default"] = ["../../assets/images/outside/flowers.png"];


    return GameEntityBuilder("flowers")
        .addComponent(ItemComponent())
        .addComponent(PositionComponent(3.4, 4.9))
        .addComponent(AnimatedSpriteComponent(animation, 32, 32, "default"))
        .build();
  }
}
