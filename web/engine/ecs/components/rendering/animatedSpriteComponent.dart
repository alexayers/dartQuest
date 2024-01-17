import '../../../rendering/animatedSprite.dart';
import '../../gameComponent.dart';

class AnimatedSpriteComponent implements GameComponent {

  AnimatedSprite animatedSprite;

  AnimatedSpriteComponent(this.animatedSprite);

  @override
  String get name => "animatedSprite";
}
