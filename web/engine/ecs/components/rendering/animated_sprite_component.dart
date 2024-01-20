import '../../../rendering/animated_sprite.dart';
import '../../game_component.dart';

class AnimatedSpriteComponent implements GameComponent {

  AnimatedSprite animatedSprite;

  AnimatedSpriteComponent(this.animatedSprite);

  @override
  String get name => "animatedSprite";
}
