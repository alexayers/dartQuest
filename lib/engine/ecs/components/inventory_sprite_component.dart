import '../../rendering/sprite.dart';
import '../game_component.dart';

class InventorySpriteComponent implements GameComponent {
  Sprite sprite;

  InventorySpriteComponent(this.sprite);

  @override
  String get name => "inventorySprite";
}
