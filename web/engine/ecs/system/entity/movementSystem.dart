import 'dart:math';

import '../../../logger/logger.dart';
import '../../../rendering/rayCaster/camera.dart';
import '../../../rendering/rayCaster/worldMap.dart';
import '../../../utils/mathUtils.dart';
import '../../components/animatedSpriteComponent.dart';
import '../../components/cameraComponent.dart';
import '../../components/positionComponent.dart';
import '../../components/velocityComponent.dart';
import '../../gameEntity.dart';
import '../../gameEntityRegistry.dart';
import '../../gameSystem.dart';

class MovementSystem implements GameSystem {
  final WorldMap _worldMap = WorldMap.instance;
  final GameEntityRegistry _gameEntityRegistry = GameEntityRegistry.instance;

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

      num dx = positionComponent.x -tempX;
      num dy = positionComponent.y - tempY;
      Vector2 npcDirection = Vector2(dx, dy).normalize();

      GameEntity player = _gameEntityRegistry.getSingleton("player");
      CameraComponent cameraComponent = player.getComponent("camera") as CameraComponent;
      Camera camera = cameraComponent.camera;

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
