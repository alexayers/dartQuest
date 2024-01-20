import '../../../rendering/spritesheet.dart';
import '../../game_component.dart';

class SpriteSheetComponent implements GameComponent {

  SpriteSheet spriteSheet;
  String spriteName;

  SpriteSheetComponent(this.spriteSheet, this.spriteName);

  @override
  String get name => "spriteSheet";

}
