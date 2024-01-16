import 'dart:math';

import '../../logger/logger.dart';
import '../../rendering/renderer.dart';
import '../../rendering/sprite.dart';
import '../gameComponent.dart';

class AnimatedSpriteComponent implements GameComponent {
  int _tick = 0;
  final int _maxTicks = 8;
  int _currentFrame = 0;
  String _currentAction = "default";
  num _currentRotation = 1;
  num ang = 0;
  final Map<String, List<Sprite>> _frames = {};
  int width;
  int height;
  num x = 0;
  num y = 0;

  AnimatedSpriteComponent(
      this.width, this.height, Map<String, List<String>> imageFiles) {
    for (String key in imageFiles.keys) {
      _frames[key] = [];
      for (String image in imageFiles[key]!) {
        _frames[key]!.add(Sprite(width, height, image));
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

  void updateSpriteRotation(num drawAng) {

  }

  set currentAction(String currentAction) {
    if (currentAction != _currentAction) {
      _currentAction = currentAction;
      _currentFrame = 0;
    }
  }

  String get currentAction {
    return _currentAction;
  }

  void render(int x, int y) {
    Sprite sprite = _frames[currentAction]![_currentFrame];
    Renderer.renderImage(sprite.image, x, y, sprite.width, sprite.height);

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
