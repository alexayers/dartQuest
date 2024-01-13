import 'dart:math';

import '../../ecs/components/doorComponent.dart';
import '../../ecs/gameEntity.dart';
import '../../logger/logger.dart';
import '../../utils/mathUtils.dart';
import 'worldMap.dart';

class Camera {
  num xPos;
  num yPos;
  num xDir;
  num yDir;
  num fov;
  late num xPlane;
  late num yPlane;

  Camera(this.xPos, this.yPos, this.xDir, this.yDir, this.fov) {
    xPlane = MathUtils.rotateVector(xDir, yDir, -pi / 2).x * fov;
    yPlane = MathUtils.rotateVector(xDir, yDir, -pi / 2).y * fov;
  }

  void move(num moveX, num moveY) {
    WorldMap worldMap = WorldMap.instance;
    GameEntity gameEntity =
        worldMap.getEntityAtPosition((xPos + moveX).floor(), yPos.floor());

    if (gameEntity.hasComponent("floor")) {
      xPos += moveX;
    }

    if (gameEntity.hasComponent("door")) {
      DoorComponent door = gameEntity.getComponent("door") as DoorComponent;

      if (door.isOpen()) {
        xPos += moveX;
      }
    }

    gameEntity =
        worldMap.getEntityAtPosition(xPos.floor(), (yPos + moveY).floor());

    if (gameEntity.hasComponent("floor")) {
      yPos += moveY;
    }

    if (gameEntity.hasComponent("door")) {
      DoorComponent door = gameEntity.getComponent("door") as DoorComponent;

      if (door.isOpen()) {
        yPos += moveY;
      }
    }
  }

  void rotate(num angle) {
    Point rDir = MathUtils.rotateVector(xDir, yDir, angle);
    xDir = rDir.x;
    yDir = rDir.y;

    Point rPlane = MathUtils.rotateVector(xPlane, yPlane, angle);
    xPlane = rPlane.x;
    yPlane = rPlane.y;
  }
}
