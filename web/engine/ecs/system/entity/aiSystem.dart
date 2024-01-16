import '../../../logger/logger.dart';
import '../../../pathFinding/aiStar.dart';
import '../../../rendering/rayCaster/camera.dart';
import '../../../utils/mathUtils.dart';
import '../../components/ai/aiComponent.dart';
import '../../components/cameraComponent.dart';
import '../../components/distanceComponent.dart';
import '../../components/interactions/attackActionComponent.dart';
import '../../components/positionComponent.dart';
import '../../components/velocityComponent.dart';
import '../../gameEntity.dart';
import '../../gameEntityRegistry.dart';
import '../../gameSystem.dart';

class AiSystem implements GameSystem {
  final GameEntityRegistry _gameEntityRegistry = GameEntityRegistry.instance;

  @override
  void processEntity(GameEntity gameEntity) {
    GameEntity player = _gameEntityRegistry.getSingleton("player");
    PositionComponent positionComponent =
        gameEntity.getComponent("position") as PositionComponent;
    VelocityComponent velocityComponent =
        gameEntity.getComponent("velocity") as VelocityComponent;
    AiComponent aiComponent = gameEntity.getComponent("ai") as AiComponent;

    switch (aiComponent.movementStyle) {
      case MovementStyle.wander:
        wander(aiComponent, velocityComponent);
        break;
      case MovementStyle.follow:
        follow(velocityComponent, positionComponent, player);
        break;
    }

    if (!aiComponent.friend) {
      DistanceComponent distanceComponent = gameEntity.getComponent("distance") as DistanceComponent;

      if (distanceComponent.distance <= 2 && DateTime.now().millisecondsSinceEpoch >= aiComponent.attackCoolDown) {
        gameEntity.addComponent(AttackActionComponent());
        aiComponent.attackCoolDown = DateTime.now().millisecondsSinceEpoch + 1000;
      }
    }
  }

  void follow(VelocityComponent velocityComponent,
      PositionComponent positionComponent, GameEntity player) {
    CameraComponent cameraComponent =
        player.getComponent("camera") as CameraComponent;
    Camera camera = cameraComponent.camera;

    AStar aStar = AStar(positionComponent.x.floor(),
        positionComponent.y.floor(), camera.xPos.floor(), camera.yPos.floor());

    if (aStar.isPathFound()) {
      List<PathNode> pathNodes = aStar.path;

      try {
        if (pathNodes[0].x > positionComponent.x.floor()) {
          velocityComponent.velX = 0.02;
        } else if (pathNodes[0].x < positionComponent.x.floor()) {
          velocityComponent.velX = -0.02;
        }

        if (pathNodes[0].y > positionComponent.y.floor()) {
          velocityComponent.velY = 0.02;
        } else if (pathNodes[0].y < positionComponent.y.floor()) {
          velocityComponent.velY = -0.02;
        }
      } catch (e) {}
    } else {
      logger(LogType.info, "oh noes");
    }
  }

  void wander(AiComponent aiComponent, VelocityComponent velocityComponent) {
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
  void removeIfPresent(GameEntity gameEntity) {}

  @override
  bool shouldRun(GameEntity gameEntity) {
    return gameEntity.hasComponent("ai");
  }


}
