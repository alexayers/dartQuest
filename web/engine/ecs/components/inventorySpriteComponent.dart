import '../../rendering/sprite.dart';
import '../gameComponent.dart';

class InventorySpriteComponent implements GameComponent {
  Sprite sprite;

  InventorySpriteComponent(this.sprite);

  @override
  String get name => "inventorySprite";
}
