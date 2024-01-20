import 'dart:math';

import '../../ecs/components/door_component.dart';
import '../../ecs/game_entity.dart';
import '../../utils/math_utils.dart';
import 'world_map.dart';

class Camera {
  num xPos;
  num yPos;
  num xDir;
  num yDir;
  num fov;
  late num xPlane;
  late num yPlane;
  final WorldMap _worldMap = WorldMap.instance;

  Camera(this.xPos, this.yPos, this.xDir, this.yDir, this.fov) {
    xPlane = MathUtils.rotateVector(xDir, yDir, -pi / 2).x * fov;
    yPlane = MathUtils.rotateVector(xDir, yDir, -pi / 2).y * fov;
  }

  void move(num moveX, num moveY) {

    GameEntity gameEntity =
    _worldMap.getEntityAtPosition((xPos + moveX).floor(), yPos.floor());

    if (npcPresent()) {
      return;
    }

    if (gameEntity.hasComponent("floor") || gameEntity.hasComponent("transparent")) {
      xPos += moveX;
    }

    if (gameEntity.hasComponent("door")) {
      DoorComponent door = gameEntity.getComponent("door") as DoorComponent;

      if (door.isOpen()) {
        xPos += moveX;
      }
    }

    gameEntity =
        _worldMap.getEntityAtPosition(xPos.floor(), (yPos + moveY).floor());

    if (gameEntity.hasComponent("floor") || gameEntity.hasComponent("transparent")) {
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

  Vector2 get position => Vector2(xPos, yPos);
  Vector2 get direction => Vector2(xDir, yDir);

  bool npcPresent() {
    bool npcInTheWay = false;


    return npcInTheWay;
  }
}
