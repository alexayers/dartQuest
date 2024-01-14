
import 'dart:html';

import 'renderer.dart';
import 'sprite.dart';

class AnimatedSprite {
  int _tick = 0;
  final int _maxTicks = 8;
  int _currentFrame = 0;
  final String _currentAction;
  final Map<String, List<ImageElement>> _frames = {};

  AnimatedSprite(Map<String,List<String>> imageFiles, this._currentAction) {

    for (String key in imageFiles.keys) {
      _frames[key] = [];
      for (String image in imageFiles[key]!) {
        ImageElement imageElement = ImageElement();
        imageElement.src = image;
        _frames[key]!.add(imageElement);
      }
    }

    _currentFrame = 0;
    _tick = 0;
  }

  void nextFrame() {
    _tick++;

    if (_tick == _maxTicks) {
      _tick = 0;
      _currentFrame++;

      if (_currentFrame == _frames[_currentAction]!.length) {
        _currentFrame = 0;
      }
    }

  }

  void render(num x, num y, int width, int height) {
    ImageElement imageElement = _frames[_currentAction]![_currentFrame];
    Renderer.renderImage(imageElement, x, y, width, height);

    _tick++;

    if (_tick == _maxTicks) {
      _tick = 0;
      _currentFrame++;

      if (_currentFrame == _frames[_currentAction]!.length) {
        _currentFrame = 0;
      }
    }

  }
}
