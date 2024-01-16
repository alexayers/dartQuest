

import '../../../../game/components/healthComponent.dart';
import '../../../audio/audioManager.dart';
import '../../../logger/logger.dart';
import '../../components/animatedSpriteComponent.dart';
import '../../components/deadComponent.dart';
import '../../components/properties/takeDamageComponent.dart';
import '../../components/sound/hurtSoundComponent.dart';
import '../../gameEntity.dart';
import '../../gameSystem.dart';

class DamageSystem implements GameSystem {
  
  AudioManager audioManager = AudioManager.instance;

  @override
  void processEntity(GameEntity gameEntity) {

    HealthComponent healthComponent = gameEntity.getComponent("health") as HealthComponent;
    TakeDamageComponent takeDamageComponent = gameEntity.getComponent("takeDamage") as TakeDamageComponent;

    healthComponent.current -= takeDamageComponent.damage;

    if (healthComponent.current <= 0) {

      healthComponent.current = 0;
      gameEntity.addComponent(DeadComponent());

      if (!gameEntity.hasComponent("camera")) {
        gameEntity.removeComponent("ai");
        gameEntity.removeComponent("health");
        AnimatedSpriteComponent animatedSpriteComponent = gameEntity
            .getComponent("animatedSprite") as AnimatedSpriteComponent;
        animatedSpriteComponent.animatedSprite.currentAction = "dead";

        logger(LogType.debug, "${gameEntity.name} is dead.");
      }
    } else {
      
      if (gameEntity.hasComponent("hurtSound")) {
        HurtSoundComponent hurtSoundComponent = gameEntity.getComponent("hurtSound") as HurtSoundComponent;
        audioManager.play(hurtSoundComponent.soundName);
      }
      
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
