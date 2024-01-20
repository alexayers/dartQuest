

import '../../engine/ecs/components/ai/ai_component.dart';
import '../../engine/ecs/components/rendering/animated_sprite_component.dart';
import '../../engine/ecs/components/distance_component.dart';
import '../../engine/ecs/components/position_component.dart';
import '../../engine/ecs/components/rendering/animated_spritesheet_component.dart';
import '../../engine/ecs/components/sound/timed_sound_component.dart';
import '../../engine/ecs/components/velocity_component.dart';
import '../../engine/ecs/game_entity.dart';
import '../../engine/ecs/game_entity_builder.dart';
import '../../engine/rendering/animated_sprite.dart';
import '../../engine/rendering/spritesheet.dart';

class Dog {



  static GameEntity create() {


    SpriteSheetDefinition spriteSheetDefinition = SpriteSheetDefinition("../../assets/images/npc/dog.png",
        ["dogWalk1","dogWalk2","dogWalk3", // no format
        "dogSit1", "dogSit2", "dogSit3"
        ],
        32, 32);

    Map<String,List<String>> animation = {};

    animation["walking"] = ["../../assets/images/npc/dog/dog1.png",
      "../../assets/images/npc/dog/dog2.png",
      "../../assets/images/npc/dog/dog3.png"];
    animation["default"] = [
      "../../assets/images/npc/dog/dogSit1.png",
      "../../assets/images/npc/dog/dogSit2.png",
      "../../assets/images/npc/dog/dogSit3.png"];


    return GameEntityBuilder("dog")
        .addComponent(DistanceComponent())
        .addComponent(VelocityComponent(0, 0))
        .addComponent(
        TimedSoundComponent("bark", "../../assets/sound/bark.wav", 2000))
        .addComponent(AiComponent(MovementStyle.wander, true))
        .addComponent(PositionComponent(3, 3))
        .addComponent(AnimatedSpriteComponent(animation, 32,32, "walking"))
        .build();
  }

}
