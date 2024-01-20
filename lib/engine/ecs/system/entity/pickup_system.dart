import '../../../rendering/rayCaster/world_map.dart';
import '../../components/distance_component.dart';
import '../../components/inventory_component.dart';
import '../../game_entity.dart';
import '../../game_system.dart';

class PickUpSystem implements GameSystem {
  final WorldMap _worldMap = WorldMap.instance;

  @override
  void processEntity(GameEntity gameEntity) {
    InventoryComponent inventory =
        gameEntity.getComponent("inventory") as InventoryComponent;

    List<GameEntity> gameEntities = _worldMap.getWorldItems();

    for (int i = 0; i < gameEntities.length; i++) {
      GameEntity gameEntity = gameEntities[i];
      DistanceComponent distance =
          gameEntity.getComponent("distance") as DistanceComponent;

      if (distance.distance < 1) {
        _worldMap.removeWorldItem(gameEntity);
      }
    }
  }

  @override
  void removeIfPresent(GameEntity gameEntity) {
    gameEntity.removeComponent("pickUp");
  }

  @override
  bool shouldRun(GameEntity gameEntity) {
    return gameEntity.hasComponent("pickUp");
  }
}
