

import '../../engine/ecs/components/ai/aiComponent.dart';
import '../../engine/ecs/components/animatedSpriteComponent.dart';
import '../../engine/ecs/components/distanceComponent.dart';
import '../../engine/ecs/components/positionComponent.dart';
import '../../engine/ecs/components/sound/timedSoundComponent.dart';
import '../../engine/ecs/components/velocityComponent.dart';
import '../../engine/ecs/gameEntity.dart';
import '../../engine/ecs/gameEntityBuilder.dart';
import '../../engine/rendering/animatedSprite.dart';

class Dog {



  static GameEntity create() {
    Map<String, List<String>> animation = {};

    animation["walking"] = [
      "../../assets/images/npc/dog/dog1.png",
      "../../assets/images/npc/dog/dog2.png",
      "../../assets/images/npc/dog/dog1.png",
      "../../assets/images/npc/dog/dog3.png"
    ];

    animation["default"] = [
      "../../assets/images/npc/dog/dogSit1.png",
      "../../assets/images/npc/dog/dogSit2.png",
      "../../assets/images/npc/dog/dogSit1.png",
      "../../assets/images/npc/dog/dogSit3.png"
    ];

    AnimatedSprite animatedSprite = AnimatedSprite(animation, 32, 32, "walking");

    return GameEntityBuilder("dog")
        .addComponent(DistanceComponent())
        .addComponent(VelocityComponent(0, 0))
        .addComponent(
        TimedSoundComponent("bark", "../../assets/sound/bark.wav", 2000))
        .addComponent(AiComponent(MovementStyle.wander, true))
        .addComponent(PositionComponent(3, 3))
        .addComponent(AnimatedSpriteComponent(animatedSprite))
        .build();
  }

}
