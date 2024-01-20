import '../../engine/ecs/components/rendering/animated_sprite_component.dart';
import '../../engine/ecs/game_component.dart';

class OnPowerAnimatedSpriteComponent implements GameComponent {
  AnimatedSpriteComponent animatedSpriteComponent;

  OnPowerAnimatedSpriteComponent(this.animatedSpriteComponent);

  @override
  String get name => "onPowerAnimatedSprite";
}
