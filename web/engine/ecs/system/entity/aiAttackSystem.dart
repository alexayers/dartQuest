


import '../../../audio/audioManager.dart';
import '../../../logger/logger.dart';
import '../../../rendering/rayCaster/worldMap.dart';
import '../../components/cameraComponent.dart';
import '../../components/damageComponent.dart';
import '../../components/inventoryComponent.dart';
import '../../components/properties/takeDamageComponent.dart';
import '../../components/useSound.dart';
import '../../gameEntity.dart';
import '../../gameEntityRegistry.dart';
import '../../gameSystem.dart';

class AiAttackSystem implements GameSystem {

  final GameEntityRegistry _gameEntityRegistry = GameEntityRegistry.instance;
  final AudioManager _audioManager = AudioManager.instance;

  @override
  void processEntity(GameEntity gameEntity) {

    GameEntity player = _gameEntityRegistry.getSingleton("player");

    InventoryComponent inventory =
    gameEntity.getComponent("inventory") as InventoryComponent;
    GameEntity holdingItem = inventory.getCurrentItem()!;
    DamageComponent damageComponent = holdingItem.getComponent("damage") as DamageComponent;

    if (holdingItem.hasComponent("useSound")) {

      UseSound useSound = holdingItem.getComponent("useSound") as UseSound;
      _audioManager.play(useSound.soundName);
    }

    player.addComponent(TakeDamageComponent(damageComponent.amount));
  }

  @override
  void removeIfPresent(GameEntity gameEntity) {
    gameEntity.removeComponent("attackAction");
  }

  @override
  bool shouldRun(GameEntity gameEntity) {
    return gameEntity.hasComponent("ai") && gameEntity.hasComponent("attackAction");
  }




}
