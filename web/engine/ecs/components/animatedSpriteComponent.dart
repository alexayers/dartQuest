import '../../rendering/renderer.dart';
import '../../rendering/sprite.dart';
import '../gameComponent.dart';

class AnimatedSpriteComponent implements GameComponent {
  int _tick = 0;
  int _maxTicks = 7;
  int _currentFrame = 0;
  List<Sprite> _frames = [];
  int _x;
  int _y;

  AnimatedSpriteComponent(this._x, this._y, List<String> imageFiles) {
    _frames = [];

    for (var imageFile in imageFiles) {
      _frames.add(Sprite(_x, _y, imageFile));
    }

    _currentFrame = 0;
    _tick = 0;
  }

  addSprite(Sprite sprite) {
    _frames.add(sprite);
  }

  Sprite currentSprite() {
    return _frames[_currentFrame];
  }

  void nextFrame() {
    _tick++;

    if (_tick == _maxTicks) {
      _tick = 0;
      _currentFrame++;

      if (_currentFrame == _frames.length) {
        _currentFrame = 0;
      }
    }
  }

  void render() {
    Sprite sprite = _frames[_currentFrame];
    Renderer.renderImage(sprite.image, _x, _y, sprite.width, sprite.height);

    _tick++;

    if (_tick == _maxTicks) {
      _tick = 0;
      _currentFrame++;

      if (_currentFrame == _frames.length) {
        _currentFrame = 0;
      }
    }
  }

  @override
  String get name => "animatedSprite";
}
