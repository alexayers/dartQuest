import '../../../rendering/rayCaster/worldMap.dart';
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

    if (canWalk(tempX, tempY)) {
      positionComponent.x += velocityComponent.velX;
      positionComponent.y += velocityComponent.velY;
    }

    velocityComponent.velX = 0;
    velocityComponent.velY = 0;
  }

  bool canWalk(int x, int y) {
    int checkMapX = x.floor();
    int checkMapY = y.floor();

    GameEntity gameEntity = _worldMap.getEntityAtPosition(checkMapX, checkMapY);

    return !gameEntity.hasComponent("wall");
  }

  @override
  void removeIfPresent(GameEntity gameEntity) {}

  @override
  bool shouldRun(GameEntity gameEntity) {
    return gameEntity.hasComponent("velocity") &&
        gameEntity.hasComponent("position");
  }
}
