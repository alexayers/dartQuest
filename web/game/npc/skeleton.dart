

import '../../engine/ecs/components/ai/aiComponent.dart';
import '../../engine/ecs/components/animatedSpriteComponent.dart';
import '../../engine/ecs/components/damageComponent.dart';
import '../../engine/ecs/components/distanceComponent.dart';
import '../../engine/ecs/components/inventoryComponent.dart';
import '../../engine/ecs/components/positionComponent.dart';
import '../../engine/ecs/components/useSound.dart';
import '../../engine/ecs/components/velocityComponent.dart';
import '../../engine/ecs/gameEntity.dart';
import '../../engine/ecs/gameEntityBuilder.dart';
import '../components/healthComponent.dart';

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
      .addComponent(UseSound("bone", "../../assets/sound/bone.wav"))
          .build()
    );

    return GameEntityBuilder("skeleton")
        .addComponent(DistanceComponent())
        .addComponent(inventoryComponent)
        .addComponent(VelocityComponent(0,0))
        .addComponent(AiComponent(MovementStyle.follow, false))
        .addComponent(HealthComponent(5, 5))
        .addComponent(PositionComponent(5, 5))
        .addComponent(AnimatedSpriteComponent(32,32, animation))
        .build();

  }

}
