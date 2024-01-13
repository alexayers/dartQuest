import '../../rendering/sprite.dart';
import '../gameComponent.dart';

class DamagedComponent implements GameComponent {
  int damage;
  Sprite damageSprite;

  DamagedComponent(this.damage, this.damageSprite);

  @override
  String get name => "damaged";
}
