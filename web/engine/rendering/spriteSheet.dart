import 'dart:html';

import '../logger/logger.dart';
import '../utils/mathUtils.dart';

class SpriteSheetDefinition {
  String spriteSheet;
  int spriteWidth;
  int spriteHeight;
  late int perRow;
  late int perCol;
  List<String> sprites;

  SpriteSheetDefinition(
      this.spriteSheet, this.sprites, this.spriteWidth, this.spriteHeight);
}

class SpriteLocation {
  int lx;
  int ly;
  int hx;
  int hy;

  SpriteLocation(this.lx, this.ly, this.hx, this.hy);
}

class SpriteSheet {

  late final SpriteSheetDefinition spriteSheetDefinition;
  final Map<String, Vector2> spriteMap = {};
  final ImageElement image = ImageElement();

  SpriteSheet(SpriteSheetDefinition spriteSheetDefinition) {
    int offsetX = 0;
    int offsetY = 0;
    int spriteCount = 0;

    this.spriteSheetDefinition = spriteSheetDefinition;
    image.src = spriteSheetDefinition.spriteSheet;

    image.onLoad.listen((event) {
      int width = image.width!;
      int height = image.height!;
      int spritesPerRow = (width / spriteSheetDefinition.spriteWidth).floor();
      int spritesPerCol = (height / spriteSheetDefinition.spriteHeight).floor();

      int x = 0; // x position in sprite terms
      int y = 0; // y position in sprite terms

      for (String spriteName in spriteSheetDefinition.sprites) {

        spriteMap[spriteName] = Vector2(x, y);

        logger(LogType.info, "Loaded $spriteName at ${offsetX}x$offsetY");

        x++;

        // Check if we reached the end of the row
        if (x >= spritesPerRow) {
          x = 0; // Reset column position for sprites
          y++;
        }
      }

      spriteSheetDefinition.perRow = spritesPerRow;
      spriteSheetDefinition.perCol = spritesPerCol;
    });


  }

  /*
  void render(String spriteName, num x, num y, int width, int height, [bool flip = false]) {

    SpriteLocation spriteLocation = _spriteMap[spriteName]!;
    Renderer.renderClippedImage(image, spriteLocation.lx, spriteLocation.ly, spriteSheetDefinition.spriteWidth, spriteSheetDefinition.spriteHeight,
        x, y, width, height);

  }

   */

}
