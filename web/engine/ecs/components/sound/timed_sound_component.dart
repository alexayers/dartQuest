

import '../../../audio/audio_manager.dart';
import '../../../utils/math_utils.dart';
import '../../game_component.dart';

class TimedSoundComponent implements GameComponent {

  bool playThenRemove;
  String soundFile;
  String soundName;
  int delay;
  int lastPlayed;
  final AudioManager _audioManager = AudioManager.instance;

  TimedSoundComponent(this.soundName, this.soundFile, this.delay, {this.playThenRemove = true}) :lastPlayed = DateTime.now().millisecondsSinceEpoch + MathUtils.getRandomBetween(1000, 10000) {
    _audioManager.register(soundName, soundFile);
  }

  @override
  String get name => "timedSound";



}
