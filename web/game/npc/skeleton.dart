

import '../../engine/ecs/components/ai/ai_component.dart';
import '../../engine/ecs/components/rendering/animated_sprite_component.dart';
import '../../engine/ecs/components/damage_component.dart';
import '../../engine/ecs/components/distance_component.dart';
import '../../engine/ecs/components/inventory_component.dart';
import '../../engine/ecs/components/position_component.dart';
import '../../engine/ecs/components/sound/use_sound_component.dart';
import '../../engine/ecs/components/velocity_component.dart';
import '../../engine/ecs/game_entity.dart';
import '../../engine/ecs/game_entity_builder.dart';
import '../../engine/rendering/animated_sprite.dart';
import '../components/health_component.dart';

class Skeleton {



  static GameEntity create() {

    Map<String, List<String>> animation = {};

    animation["walking"] = [
      "../../assets/images/npc/skeleton/skeleton1.png",
      "../../assets/images/npc/skeleton/skeleton2.png",
      "../../assets/images/npc/skeleton/skeleton1.png",
      "../../assets/images/npc/skeleton/skeleton3.png"
    ];

    animation["default"] = [
      "../../assets/images/npc/skeleton/skeleton1.png",
      "../../assets/images/npc/skeleton/skeleton2.png",
      "../../assets/images/npc/skeleton/skeleton1.png",
      "../../assets/images/npc/skeleton/skeleton3.png"
    ];

    animation["dead"] = [
      "../../assets/images/npc/skeleton/skeletonDead.png"
    ];

    InventoryComponent inventoryComponent = InventoryComponent(1);
    inventoryComponent.addItem(
      GameEntityBuilder("skeletonFist")
      .addComponent(DamageComponent(1))
      .addComponent(UseSoundComponent("bone", "../../assets/sound/bone.wav"))
          .build()
    );

    return GameEntityBuilder("skeleton")
        .addComponent(DistanceComponent())
        .addComponent(inventoryComponent)
        .addComponent(VelocityComponent(0,0))
        .addComponent(AiComponent(MovementStyle.follow, false))
        .addComponent(HealthComponent(5, 5))
        .addComponent(PositionComponent(7, 7))
        .addComponent(AnimatedSpriteComponent(animation, 32, 32, "default"))
        .build();

  }

}
