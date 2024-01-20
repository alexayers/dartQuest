import '../../rendering/sprite.dart';
import '../game_component.dart';

class HoldingSpriteComponent implements GameComponent {
  Sprite sprite;

  HoldingSpriteComponent(this.sprite);

  @override
  String get name => "holdingSprite";
}
