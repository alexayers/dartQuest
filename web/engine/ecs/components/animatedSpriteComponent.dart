import 'dart:math';

import '../../logger/logger.dart';
import '../../rendering/animatedSprite.dart';
import '../../rendering/renderer.dart';
import '../../rendering/sprite.dart';
import '../gameComponent.dart';

class AnimatedSpriteComponent implements GameComponent {

  AnimatedSprite animatedSprite;

  AnimatedSpriteComponent(this.animatedSprite);

  /*
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
    num deltaAng = drawAng - ang + pi; // Adding pi to adjust the angle range
    while (deltaAng < 0) {
      deltaAng += pi * 2;
    }
    while (deltaAng > pi * 2) {
      deltaAng -= pi * 2;
    }

    // Assuming you want to map the angle to 4 discrete rotation states (0, 1, 2, 3)
    int totalStates = 4;
    num newRotation = (deltaAng / (2 * pi) * totalStates).floor();

    if (_currentRotation != newRotation) {
      _currentRotation = newRotation;
      logger(LogType.info, _currentRotation.toString());
    }
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

   */

  @override
  String get name => "animatedSprite";
}
