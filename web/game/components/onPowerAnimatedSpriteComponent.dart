import '../../engine/ecs/components/rendering/animatedSpriteComponent.dart';
import '../../engine/ecs/gameComponent.dart';

class OnPowerAnimatedSpriteComponent implements GameComponent {
  AnimatedSpriteComponent animatedSpriteComponent;

  OnPowerAnimatedSpriteComponent(this.animatedSpriteComponent);

  @override
  String get name => "onPowerAnimatedSprite";
}
