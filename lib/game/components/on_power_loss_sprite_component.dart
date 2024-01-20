import '../../engine/ecs/game_component.dart';
import '../../engine/rendering/sprite.dart';

class OnPowerLossSpriteComponent implements GameComponent {
  Sprite sprite;

  OnPowerLossSpriteComponent(this.sprite);

  @override
  String get name => "onPowerLossSprite";
}
