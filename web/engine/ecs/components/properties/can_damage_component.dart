import '../../../rendering/sprite.dart';
import '../../game_component.dart';

class CanDamageComponent implements GameComponent {
  Sprite sprite;

  CanDamageComponent(this.sprite);

  @override
  String get name => "canDamage";
}
