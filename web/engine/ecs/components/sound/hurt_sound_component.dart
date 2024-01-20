import '../../../audio/audio_manager.dart';
import '../../game_component.dart';

class HurtSoundComponent implements GameComponent {

  String soundFile;
  String soundName;
  final AudioManager _audioManager = AudioManager.instance;

  HurtSoundComponent(this.soundName, this.soundFile) {
    _audioManager.register(soundName, soundFile);
  }


  @override
  String get name => "hurtSound";


}
