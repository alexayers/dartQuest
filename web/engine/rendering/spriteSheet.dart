import 'dart:html';

import '../logger/logger.dart';
import 'renderer.dart';

class SpriteSheetDefinition {
  String spriteSheet;
  int spriteWidth;
  int spriteHeight;
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
  final Map<String, int> spriteMap = {};
  final ImageElement image = ImageElement();

  SpriteSheet(SpriteSheetDefinition spriteSheetDefinition) {
    int offsetX = 0;
    int offsetY = 0;
    int spriteCount = 0;

    this.spriteSheetDefinition = spriteSheetDefinition;
    image.src = spriteSheetDefinition.spriteSheet;

    image.onLoad.listen((event) {
      int width = image.width!;
      int spritesPerRow = (width / spriteSheetDefinition.spriteWidth).floor();
      int i = 0;

      for (String spriteName in spriteSheetDefinition.sprites) {
        spriteMap[spriteName] = i;
        spriteCount++;
        i++;

        logger(LogType.info, "Loaded $spriteName at ${offsetX}x$offsetY");

        if (spriteCount == spritesPerRow) {
          spriteCount = 0;
          offsetX = 0;
          offsetY += spriteSheetDefinition.spriteHeight;
        } else {
          offsetX += spriteSheetDefinition.spriteWidth;
        }
      }
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
