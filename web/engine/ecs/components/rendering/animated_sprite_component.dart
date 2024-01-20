import '../../../rendering/animated_sprite.dart';
import '../../game_component.dart';

class AnimatedSpriteComponent implements GameComponent {

  AnimatedSprite animatedSprite;

  AnimatedSpriteComponent(Map<String,List<String>> imageFiles, int width, int height, String currentAction) :
        animatedSprite = AnimatedSprite(imageFiles, width, height, currentAction);


  @override
  String get name => "animatedSprite";
}
