

import '../../../audio/audioManager.dart';
import '../../../utils/mathUtils.dart';
import '../../components/timedSoundComponent.dart';
import '../../gameEntity.dart';
import '../../gameSystem.dart';

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
