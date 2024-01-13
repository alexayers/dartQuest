

import '../../../logger/logger.dart';
import '../../../rendering/rayCaster/camera.dart';
import '../../../rendering/rayCaster/worldMap.dart';
import '../../components/cameraComponent.dart';
import '../../components/distanceComponent.dart';
import '../../components/inventoryComponent.dart';
import '../../gameEntity.dart';
import '../../gameEntityRegistry.dart';
import '../../gameSystem.dart';

class AttackSystem implements GameSystem {

  final WorldMap _worldMap = WorldMap.instance;
  final GameEntityRegistry _gameEntityRegistry = GameEntityRegistry.instance;

  @override
  void processEntity(GameEntity gameEntity) {

    GameEntity player = _gameEntityRegistry.getSingleton("player");

    CameraComponent cameraComponent = player.getComponent("camera") as CameraComponent;

    InventoryComponent inventory =
    player.getComponent("inventory") as InventoryComponent;
    GameEntity holdingItem = inventory.getCurrentItem()!;

    if (isNpc(cameraComponent.camera)) {
      attackNpc(cameraComponent.camera);
    }

  }

  bool isNpc(Camera camera) {
    List<GameEntity> npcs = _worldMap.worldDefinition.items;

    if (npcs.isEmpty) {
      return false;
    }

    for (GameEntity npc in npcs) {

      DistanceComponent distanceComponent = npc.getComponent("distance") as DistanceComponent;

      if (distanceComponent.distance <= 1) {
        return true;
      }
    }

    return false;
  }

  void attackNpc(Camera camera) {
    List<GameEntity> npcs = _worldMap.worldDefinition.items;


    for (GameEntity npc in npcs) {

      DistanceComponent distanceComponent = npc.getComponent("distance") as DistanceComponent;

      if (distanceComponent.distance <= 1) {

        logger(LogType.debug, "You attacked ${npc.name}");
        break;

      }
    }
  }

  @override
  void removeIfPresent(GameEntity gameEntity) {
    gameEntity.removeComponent("attackAction");
  }

  @override
  bool shouldRun(GameEntity gameEntity) {
    return gameEntity.hasComponent("attackAction");
  }

}
