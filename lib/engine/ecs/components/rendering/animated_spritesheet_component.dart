import '../../../rendering/spritesheet.dart';
import '../../game_component.dart';

class AnimatedSpriteSheetComponent implements GameComponent {

  SpriteSheet spriteSheet;
  Map<String,List<String>> animation;
  String currentAction;

  AnimatedSpriteSheetComponent(this.spriteSheet, this.animation, this.currentAction);

  @override
  String get name => "animatedSpriteSheet";

}
