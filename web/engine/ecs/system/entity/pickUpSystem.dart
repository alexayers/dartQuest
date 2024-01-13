import '../../../rendering/rayCaster/worldMap.dart';
import '../../components/distanceComponent.dart';
import '../../components/inventoryComponent.dart';
import '../../gameEntity.dart';
import '../../gameSystem.dart';

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
