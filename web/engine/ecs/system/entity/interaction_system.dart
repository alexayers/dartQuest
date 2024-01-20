import '../../../rendering/rayCaster/camera.dart';
import '../../../rendering/rayCaster/world_map.dart';
import '../../components/camera_component.dart';
import '../../components/properties/can_interact_component.dart';
import '../../game_entity.dart';
import '../../game_system.dart';

class InteractionSystem implements GameSystem {
  final WorldMap _worldMap = WorldMap.instance;

  @override
  void processEntity(GameEntity gameEntity) {
    CameraComponent cameraComponent  = gameEntity.getComponent("camera") as CameraComponent;

    if (!isDamaged(cameraComponent.camera)) {
      if (!interactDoor(cameraComponent.camera)) {
        interactObject(cameraComponent.camera);
      }
    }


  }

  bool isDamaged(Camera camera) {
    int checkMapX = (camera.xPos + camera.xDir).floor();
    int checkMapY = (camera.yPos + camera.yDir).floor();

    int checkMapX2 = (camera.xPos + camera.xDir * 2).floor();
    int checkMapY2 = (camera.yPos + camera.yDir * 2).floor();

    GameEntity gameEntity  = _worldMap.getEntityAtPosition(checkMapX, checkMapY);

    if (gameEntity.hasComponent("damaged")) {
      return true;
    }

    gameEntity = _worldMap.getEntityAtPosition(checkMapX2, checkMapY2);

    if (gameEntity.hasComponent("damaged")) {
      return true;
    }

    return false;
  }

  void interactObject(Camera camera) {
    int checkMapX = (camera.xPos + camera.xDir).floor();
    int checkMapY = (camera.yPos + camera.yDir).floor();

    int checkMapX2 = (camera.xPos + camera.xDir * 2).floor();
    int checkMapY2 = (camera.yPos + camera.yDir * 2).floor();

    GameEntity gameEntity  = _worldMap.getEntityAtPosition(checkMapX, checkMapY);

    if (gameEntity.hasComponent("canInteract")) {
      CanInteractComponent canInteract  = gameEntity.getComponent("canInteract") as CanInteractComponent;

      if (canInteract.callBack != null) {
          canInteract.callBack!();
      }


      return;
    }

    gameEntity = _worldMap.getEntityAtPosition(checkMapX2, checkMapY2);

    if (gameEntity.hasComponent("canInteract")) {

      CanInteractComponent canInteract  = gameEntity.getComponent("canInteract") as CanInteractComponent;

      if (canInteract.callBack != null) {
        canInteract.callBack!();
      }

      return;
    }
  }

  bool interactDoor(Camera camera) {
    int checkMapX = (camera.xPos + camera.xDir).floor();
    int checkMapY = (camera.yPos + camera.yDir).floor();

    int checkMapX2 = (camera.xPos + camera.xDir * 2).floor();
    int checkMapY2 = (camera.yPos + camera.yDir * 2).floor();

    GameEntity gameEntity = _worldMap.getEntityAtPosition(checkMapX, checkMapY);

    if (gameEntity.hasComponent("door") ||
        gameEntity.hasComponent("pushWall") &&
            _worldMap.getDoorState(checkMapX, checkMapY) == DoorState.closed) {
      //Open door in front of camera
      _worldMap.setDoorState(checkMapX, checkMapY, DoorState.opening);
      return true;
    }

    gameEntity = _worldMap.getEntityAtPosition(checkMapX2, checkMapY2);

    if (gameEntity.hasComponent("door") ||
        gameEntity.hasComponent("pushWall") &&
            _worldMap.getDoorState(checkMapX2, checkMapY2) ==
                DoorState.closed) {
      _worldMap.setDoorState(checkMapX2, checkMapY2, DoorState.opening);
      return true;
    }

    gameEntity = _worldMap.getEntityAtPosition(checkMapX, checkMapY);

    if (gameEntity.hasComponent("door") ||
        gameEntity.hasComponent("pushWall") &&
            _worldMap.getDoorState(checkMapX, checkMapY) == DoorState.open) {
      //Open door in front of camera
      _worldMap.setDoorState(checkMapX, checkMapY, DoorState.closing);
      return true;
    }

    gameEntity = _worldMap.getEntityAtPosition(checkMapX2, checkMapY2);

    if (gameEntity.hasComponent("door") ||
        gameEntity.hasComponent("pushWall") &&
            _worldMap.getDoorState(checkMapX2, checkMapY2) == DoorState.open) {
      _worldMap.setDoorState(checkMapX2, checkMapY2, DoorState.closing);
      return true;
    }

    gameEntity =
        _worldMap.getEntityAtPosition(camera.xPos.floor(), camera.yPos.floor());

    if (gameEntity.hasComponent("door")) {
      //Avoid getting stuck in doors
      _worldMap.setDoorState(
          camera.xPos.floor(), camera.yPos.floor(), DoorState.opening);
    }

    return false;
  }

  @override
  void removeIfPresent(GameEntity gameEntity) {
    gameEntity.removeComponent("interacting");
  }

  @override
  bool shouldRun(GameEntity gameEntity) {
    return gameEntity.hasComponent("camera") &&
        gameEntity.hasComponent("interacting");
  }


}
