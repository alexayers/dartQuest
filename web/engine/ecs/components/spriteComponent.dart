import '../../rendering/sprite.dart';
import '../gameComponent.dart';

class SpriteComponent implements GameComponent {
  Sprite sprite;

  SpriteComponent(Sprite value) : sprite = value;

  @override
  String get name => "sprite";
}
