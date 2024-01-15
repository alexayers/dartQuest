

import '../../../audio/audioManager.dart';
import '../../gameComponent.dart';

class UseSoundComponent implements GameComponent {

  String soundFile;
  String soundName;
  final AudioManager _audioManager = AudioManager.instance;

  UseSoundComponent(this.soundName, this.soundFile) {
    _audioManager.register(soundName, soundFile);
  }


  @override
  String get name => "useSound";


}
