import '../../../engine/ecs/components/damageComponent.dart';
import '../../../engine/ecs/components/deadComponent.dart';
import '../../../engine/ecs/gameEntity.dart';
import '../../../engine/ecs/gameSystem.dart';
import '../../components/healthComponent.dart';

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
