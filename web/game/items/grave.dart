

import '../../engine/ecs/components/animatedSpriteComponent.dart';
import '../../engine/ecs/components/itemComponent.dart';
import '../../engine/ecs/components/positionComponent.dart';
import '../../engine/ecs/gameEntityBuilder.dart';
import '../../engine/rendering/animatedSprite.dart';

class Grave {


  static create() {

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
