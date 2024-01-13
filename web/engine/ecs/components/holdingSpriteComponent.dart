import '../../rendering/sprite.dart';
import '../gameComponent.dart';

class HoldingSpriteComponent implements GameComponent {
  Sprite sprite;

  HoldingSpriteComponent(this.sprite);

  @override
  String get name => "holdingSprite";
}
