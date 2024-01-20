import '../../../engine/ecs/components/damage_component.dart';
import '../../../engine/ecs/components/dead_component.dart';
import '../../../engine/ecs/game_entity.dart';
import '../../../engine/ecs/game_system.dart';
import '../../components/health_component.dart';

class HealthSystem implements GameSystem {
  @override
  void processEntity(GameEntity gameEntity) {
    HealthComponent health =
        gameEntity.getComponent("health") as HealthComponent;
    DamageComponent damage =
        gameEntity.getComponent("damage") as DamageComponent;

    health.current -= damage.amount;

    if (health.current <= 0) {
      health.current = 0;
      gameEntity.addComponent(DeadComponent());
    }
  }

  @override
  void removeIfPresent(GameEntity gameEntity) {
    // TODO: implement removeIfPresent
  }

  @override
  bool shouldRun(GameEntity gameEntity) {
    return gameEntity.hasComponent("health") &&
        gameEntity.hasComponent("damage");
  }
}
