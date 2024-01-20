

import '../../../audio/audio_manager.dart';
import '../../../logger/logger.dart';
import '../../../rendering/rayCaster/camera.dart';
import '../../../rendering/rayCaster/world_map.dart';
import '../../components/camera_component.dart';
import '../../components/damage_component.dart';
import '../../components/distance_component.dart';
import '../../components/inventory_component.dart';
import '../../components/properties/take_damage_component.dart';
import '../../components/sound/use_sound_component.dart';
import '../../game_entity.dart';
import '../../game_entity_registry.dart';
import '../../game_system.dart';

class AttackSystem implements GameSystem {

  final WorldMap _worldMap = WorldMap.instance;
  final GameEntityRegistry _gameEntityRegistry = GameEntityRegistry.instance;
  final AudioManager _audioManager = AudioManager.instance;

  @override
  void processEntity(GameEntity gameEntity) {

    GameEntity player = _gameEntityRegistry.getSingleton("player");

    CameraComponent cameraComponent = player.getComponent("camera") as CameraComponent;

    InventoryComponent inventory =
    player.getComponent("inventory") as InventoryComponent;
    GameEntity holdingItem = inventory.getCurrentItem()!;

    if (holdingItem.hasComponent("useSound")) {

      UseSoundComponent useSound = holdingItem.getComponent("useSound") as UseSoundComponent;
      _audioManager.play(useSound.soundName);
    }

    if (isNpc(cameraComponent.camera)) {
      attackNpc(cameraComponent.camera, holdingItem);
    }

  }

  bool isNpc(Camera camera) {
    List<GameEntity> npcs = _worldMap.worldDefinition.npcs;

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

  void attackNpc(Camera camera,GameEntity holdingItem) {
    List<GameEntity> npcs = _worldMap.worldDefinition.npcs;


    for (GameEntity npc in npcs) {

      DistanceComponent distanceComponent = npc.getComponent("distance") as DistanceComponent;

      if (distanceComponent.distance <= 1 && npc.hasComponent("health")) {



        DamageComponent damageComponent = holdingItem.getComponent("damage") as DamageComponent;

        npc.addComponent(TakeDamageComponent(damageComponent.amount));

        logger(LogType.debug, "You attacked ${npc.name} for ${damageComponent.amount} points of damage");

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
    return gameEntity.hasComponent("attackAction") && gameEntity.hasComponent("camera");
  }

}
