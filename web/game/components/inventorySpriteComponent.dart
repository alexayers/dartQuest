import '../../engine/ecs/gameComponent.dart';
import '../../engine/rendering/sprite.dart';

class InventorySpriteComponent implements GameComponent {
  Sprite sprite;

  InventorySpriteComponent(this.sprite);

  @override
  String get name => "inventorySprite";
}
