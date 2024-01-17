

import '../../engine/ecs/components/rendering/animatedSpriteComponent.dart';
import '../../engine/ecs/components/itemComponent.dart';
import '../../engine/ecs/components/positionComponent.dart';
import '../../engine/ecs/gameEntityBuilder.dart';
import '../../engine/rendering/animatedSprite.dart';

class Flower {

  static create() {
    Map<String, List<String>> animation = {};
    animation["default"] = ["../../assets/images/outside/flowers.png"];

    AnimatedSprite animatedSprite = AnimatedSprite(animation, 32, 32, "default");

    return GameEntityBuilder("flowers")
        .addComponent(ItemComponent())
        .addComponent(PositionComponent(3.4, 4.9))
        .addComponent(AnimatedSpriteComponent(animatedSprite))
        .build();
  }
}
