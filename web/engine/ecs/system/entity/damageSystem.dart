

import '../../../../game/components/healthComponent.dart';
import '../../../logger/logger.dart';
import '../../components/animatedSpriteComponent.dart';
import '../../components/deadComponent.dart';
import '../../components/properties/takeDamageComponent.dart';
import '../../gameEntity.dart';
import '../../gameSystem.dart';

class DamageSystem implements GameSystem {

  @override
  void processEntity(GameEntity gameEntity) {

    HealthComponent healthComponent = gameEntity.getComponent("health") as HealthComponent;
    TakeDamageComponent takeDamageComponent = gameEntity.getComponent("takeDamage") as TakeDamageComponent;

    healthComponent.current -= takeDamageComponent.damage;

    if (healthComponent.current <= 0) {
      gameEntity.addComponent(DeadComponent());
      gameEntity.removeComponent("ai");
      gameEntity.removeComponent("health");
      AnimatedSpriteComponent animatedSpriteComponent = gameEntity.getComponent("animatedSprite") as AnimatedSpriteComponent;
      animatedSpriteComponent.currentAction = "dead";

      logger(LogType.debug, "${gameEntity.name} is dead.");
    }

  }

  @override
  void removeIfPresent(GameEntity gameEntity) {
    gameEntity.removeComponent("takeDamage");
  }

  @override
  bool shouldRun(GameEntity gameEntity) {
    return gameEntity.hasComponent("takeDamage") && gameEntity.hasComponent("health");
  }

}
