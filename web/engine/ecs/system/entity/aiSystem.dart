

import '../../../utils/mathUtils.dart';
import '../../components/ai/aiComponent.dart';
import '../../components/velocityComponent.dart';
import '../../gameEntity.dart';
import '../../gameSystem.dart';

class AiSystem implements GameSystem {

  @override
  void processEntity(GameEntity gameEntity) {

      VelocityComponent velocityComponent = gameEntity.getComponent("velocity") as VelocityComponent;
      AiComponent aiComponent = gameEntity.getComponent("ai") as AiComponent;

      aiComponent.ticksSinceLastChange++;

      if (aiComponent.ticksSinceLastChange == 100) {
        aiComponent.ticksSinceLastChange = 0;
        aiComponent.currentDirection = MathUtils.getRandomBetween(1, 4);
      }

      switch (aiComponent.currentDirection) {
        case 1:
          velocityComponent.velX = 0.02;
          break;
        case 2:
          velocityComponent.velX = -0.02;
          break;
        case 3:
          velocityComponent.velY = 0.02;
          break;
        case 4:
          velocityComponent.velY = -0.02;
          break;
      }

  }

  @override
  void removeIfPresent(GameEntity gameEntity) {

  }

  @override
  bool shouldRun(GameEntity gameEntity) {
    return gameEntity.hasComponent("ai");
  }



}
