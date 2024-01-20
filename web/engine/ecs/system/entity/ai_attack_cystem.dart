


import '../../../audio/audio_manager.dart';
import '../../components/damage_component.dart';
import '../../components/inventory_component.dart';
import '../../components/properties/take_damage_component.dart';
import '../../components/sound/use_sound_component.dart';
import '../../game_entity.dart';
import '../../game_entity_registry.dart';
import '../../game_system.dart';

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

      UseSoundComponent useSound = holdingItem.getComponent("useSound") as UseSoundComponent;
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
