import '../../logger/logger.dart';
import '../../rendering/renderer.dart';
import '../../rendering/sprite.dart';
import '../gameComponent.dart';

class AnimatedSpriteComponent implements GameComponent {
  int _tick = 0;
  final int _maxTicks = 8;
  int _currentFrame = 0;
  String currentAction = "idle";
  final Map<String, List<Sprite>> _frames = {};
  int _x;
  int _y;

  AnimatedSpriteComponent(this._x, this._y, Map<String,List<String>> imageFiles) {

    for (String key in imageFiles.keys) {
      _frames[key] = [];
      logger(LogType.debug, "$key");
      for (String image in imageFiles[key]!) {
        logger(LogType.debug, image);
        _frames[key]!.add(Sprite(_x, _y, image));
      }
    }

    _currentFrame = 0;
    _tick = 0;
  }

  Sprite currentSprite() {
    return _frames[currentAction]![_currentFrame];
  }

  void nextFrame() {
    _tick++;

    if (_tick == _maxTicks) {
      _tick = 0;
      _currentFrame++;

      if (_currentFrame == _frames[currentAction]!.length) {
        _currentFrame = 0;
      }
    }

  }

  void render() {
    Sprite sprite = _frames[currentAction]![_currentFrame];
    Renderer.renderImage(sprite.image, _x, _y, sprite.width, sprite.height);

    _tick++;

    if (_tick == _maxTicks) {
      _tick = 0;
      _currentFrame++;

      if (_currentFrame == _frames[currentAction]!.length) {
        _currentFrame = 0;
      }
    }

    logger(LogType.debug, "animated");
  }

  @override
  String get name => "animatedSprite";
}
