

import '../../engine/ecs/components/rendering/animated_sprite_component.dart';
import '../../engine/ecs/components/item_component.dart';
import '../../engine/ecs/components/position_component.dart';
import '../../engine/ecs/game_entity_builder.dart';
import '../../engine/rendering/animated_sprite.dart';
import '../../engine/rendering/spritesheet.dart';

class Grave {


  static create(SpriteSheet spriteSheet) {

    Map<String, List<String>> animation = {};
    animation["default"] = ["../../assets/images/outside/grave.png"];

    AnimatedSprite animatedSprite = AnimatedSprite(animation, 32, 32, "default");

    return GameEntityBuilder("grave")
        .addComponent(ItemComponent())
        .addComponent(PositionComponent(6, 7))
        .addComponent(AnimatedSpriteComponent(animatedSprite))
        .build();
  }
}
