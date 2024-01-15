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
  num x;
  num y;

  AnimatedSpriteComponent(this.x, this.y, Map<String,List<String>> imageFiles) {

    for (String key in imageFiles.keys) {
      _frames[key] = [];
      for (String image in imageFiles[key]!) {
        _frames[key]!.add(Sprite(0, 0, image));
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

  /*
  void updateSpriteRotation(double drawAng) {
    num deltaAng;
    num newRotation;

    if (_frames.length == 1) {
      return;
    } else {
      deltaAng = drawAng - ang + 2;
      while (deltaAng < 0) {
        deltaAng += pi*2;
      }
      while (deltaAng > pi*2) {
        deltaAng -= pi*2;
      }
      newRotation = (deltaAng/4).floor();
    }

    if (_currentRotation != newRotation) { //Only update rotation if it has changed
      _currentRotation = newRotation;
      logger(LogType.info, "rotation is now $newRotation");
    }
  }

   */

   set currentAction(String currentAction) {

     if (currentAction != _currentAction) {
       _currentAction = currentAction;
       _currentFrame =0;
     }

  }

  String get currentAction {
    return _currentAction;
  }

  void render() {
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
