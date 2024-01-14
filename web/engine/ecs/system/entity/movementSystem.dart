import '../../../rendering/rayCaster/worldMap.dart';
import '../../components/animatedSpriteComponent.dart';
import '../../components/positionComponent.dart';
import '../../components/velocityComponent.dart';
import '../../gameEntity.dart';
import '../../gameSystem.dart';

class MovementSystem implements GameSystem {
  final WorldMap _worldMap = WorldMap.instance;

  @override
  void processEntity(GameEntity gameEntity) {
    VelocityComponent velocityComponent =
        gameEntity.getComponent("velocity") as VelocityComponent;
    PositionComponent positionComponent =
        gameEntity.getComponent("position") as PositionComponent;

    int tempX = (positionComponent.x + velocityComponent.velX).floor();
    int tempY = (positionComponent.y + velocityComponent.velY).floor();

    AnimatedSpriteComponent animatedSpriteComponent = gameEntity.getComponent("animatedSprite") as AnimatedSpriteComponent;


    if (canWalk(tempX, tempY)) {
      positionComponent.x += velocityComponent.velX;
      positionComponent.y += velocityComponent.velY;
      animatedSpriteComponent.currentAction = "walking";
    } else {
      animatedSpriteComponent.currentAction = "idle";
    }

    velocityComponent.velX = 0;
    velocityComponent.velY = 0;
  }

  bool canWalk(int x, int y) {
    int checkMapX = x.floor();
    int checkMapY = y.floor();

    GameEntity gameEntity = _worldMap.getEntityAtPosition(checkMapX, checkMapY);

    if (gameEntity.hasComponent("wall")) {
      return false;
    }

    gameEntity = _worldMap.getEntityAtPosition(checkMapX - 1, checkMapY - 1);

    if (gameEntity.hasComponent("wall")) {
      return false;
    }

    gameEntity = _worldMap.getEntityAtPosition(checkMapX - 1, checkMapY + 1);

    if (gameEntity.hasComponent("wall")) {
      return false;
    }

    gameEntity = _worldMap.getEntityAtPosition(checkMapX - 1, checkMapY);

    if (gameEntity.hasComponent("wall")) {
      return false;
    }

    gameEntity = _worldMap.getEntityAtPosition(checkMapX + 1, checkMapY);

    if (gameEntity.hasComponent("wall")) {
      return false;
    }

    gameEntity = _worldMap.getEntityAtPosition(checkMapX - 1, checkMapY + 1);

    if (gameEntity.hasComponent("wall")) {
      return false;
    }

    gameEntity = _worldMap.getEntityAtPosition(checkMapX, checkMapY + 1);

    if (gameEntity.hasComponent("wall")) {
      return false;
    }

    gameEntity = _worldMap.getEntityAtPosition(checkMapX + 1, checkMapY + 1);

    if (gameEntity.hasComponent("wall")) {
      return false;
    }


    return true;
  }

  @override
  void removeIfPresent(GameEntity gameEntity) {}

  @override
  bool shouldRun(GameEntity gameEntity) {
    return gameEntity.hasComponent("velocity") &&
        gameEntity.hasComponent("position");
  }
}
