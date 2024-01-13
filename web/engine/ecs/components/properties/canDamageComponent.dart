import '../../../rendering/sprite.dart';
import '../../gameComponent.dart';

class CanDamageComponent implements GameComponent {
  Sprite sprite;

  CanDamageComponent(this.sprite);

  @override
  String get name => "canDamage";
}
