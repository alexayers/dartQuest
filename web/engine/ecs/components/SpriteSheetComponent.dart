import '../../rendering/spriteSheet.dart';
import '../gameComponent.dart';

class SpriteSheetComponent implements GameComponent {

  SpriteSheet spriteSheet;
  String spriteName;

  SpriteSheetComponent(this.spriteSheet, this.spriteName);

  @override
  String get name => "spriteSheet";

}
