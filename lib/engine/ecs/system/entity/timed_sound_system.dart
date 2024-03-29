

import '../../../audio/audio_manager.dart';
import '../../../utils/math_utils.dart';
import '../../components/sound/timed_sound_component.dart';
import '../../game_entity.dart';
import '../../game_system.dart';

class TimedSoundSystem implements GameSystem {

  final AudioManager _audioManager = AudioManager.instance;

  @override
  void processEntity(GameEntity gameEntity) {
    TimedSoundComponent timedSoundComponent = gameEntity.getComponent("timedSound") as TimedSoundComponent;

    if (timedSoundComponent.lastPlayed + timedSoundComponent.delay < DateTime.now().millisecondsSinceEpoch) {
      timedSoundComponent.lastPlayed = DateTime.now().millisecondsSinceEpoch + MathUtils.getRandomBetween(9000, 20000);
      _audioManager.play(timedSoundComponent.soundName);
    }

  }

  @override
  void removeIfPresent(GameEntity gameEntity) {

  }

  @override
  bool shouldRun(GameEntity gameEntity) {
    return gameEntity.hasComponent("timedSound");
  }



}
