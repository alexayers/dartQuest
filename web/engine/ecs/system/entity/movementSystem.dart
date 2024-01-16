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

enum MovementDirection {
  up,
  down,
  left,
  right
}

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

    MovementDirection movementDirection = MovementDirection.right;

    if (velocityComponent.velX > 0) {
      movementDirection = MovementDirection.right;
    } else if (velocityComponent.velX < 0) {
      movementDirection = MovementDirection.left;
    } else if (velocityComponent.velY > 0) {
      movementDirection = MovementDirection.up;
    } else if (velocityComponent.velY > 0) {
      movementDirection = MovementDirection.down;
    }

    AnimatedSpriteComponent animatedSpriteComponent = gameEntity.getComponent("animatedSprite") as AnimatedSpriteComponent;

    //logger(logType, msg)
    
    if (tempX > positionComponent.x) {
      logger(LogType.info, "moving...");
    } else if (tempX < positionComponent.x) {
    //  logger(LogType.info, "moving...");
    } else if (tempY > positionComponent.y) {
   //   logger(LogType.info, "moving...");
    } else if (tempY < positionComponent.y) {
      //logger(LogType.info, "moving...");
    }

    if (canWalk(tempX, tempY, movementDirection)) {
      positionComponent.x += velocityComponent.velX;
      positionComponent.y += velocityComponent.velY;
      animatedSpriteComponent.currentAction = "walking";

      GameEntity player = _gameEntityRegistry.getSingleton("player");
      CameraComponent cameraComponent = player.getComponent("camera") as CameraComponent;
      Camera camera = cameraComponent.camera;


    } else {
      animatedSpriteComponent.currentAction = "default";
    }

    velocityComponent.velX = 0;
    velocityComponent.velY = 0;
  }



  bool canWalk(int x, int y, MovementDirection movementDirection) {
    int checkMapX = x.floor();
    int checkMapY = y.floor();

    GameEntity gameEntity = _worldMap.getEntityAtPosition(checkMapX, checkMapY);

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
        gameEntity.hasComponent("position") && !gameEntity.hasComponent("dead");
  }
}
