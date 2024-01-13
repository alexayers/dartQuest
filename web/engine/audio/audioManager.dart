import '../gameEvent/gameEvent.dart';
import 'audioFile.dart';

class AudioManager {
  static AudioManager? _instance;
  final bool _audioEnabled = true;
  final Map<String, AudioFile> _soundMap = {};

  AudioManager._privateConstructor();

  static AudioManager get instance {
    _instance ??= AudioManager._privateConstructor();

    return _instance!;
  }

  register(String name, String audioFile, [bool loop = false]) {
    _soundMap[name] = AudioFile(audioFile, loop);
  }

  void play(String name) {
    if (_audioEnabled) {
      _soundMap[name]?.play();
    }
  }

  void stop(String name) {
    if (_audioEnabled) {
      _soundMap[name]?.stop();
    }
  }

  void handleEvent(GameEvent gameEvent) {
    play(gameEvent.payload);
  }
}
