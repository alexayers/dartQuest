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

  late final SpriteSheetDefinition _spriteSheetDefinition;
  final Map<String, SpriteLocation> _spriteMap = {};
  final ImageElement _image = ImageElement();

  void load(SpriteSheetDefinition spriteSheetDefinition) {
    int offsetX = 0;
    int offsetY = 0;
    int spriteCount = 0;

    _spriteSheetDefinition = spriteSheetDefinition;
    _image.src = spriteSheetDefinition.spriteSheet;

    _image.onLoad.listen((event) {
      int width = _image.width!;
      int spritesPerRow = (width / spriteSheetDefinition.spriteWidth).floor();

      for (String spriteName in spriteSheetDefinition.sprites) {
        _spriteMap[spriteName] = SpriteLocation(
            offsetX,
            offsetY,
            offsetX + spriteSheetDefinition.spriteWidth,
            offsetY + spriteSheetDefinition.spriteHeight);
        spriteCount++;

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

  void render(String spriteName, num x, num y, int width, int height, [bool flip = false]) {

    SpriteLocation spriteLocation = _spriteMap[spriteName]!;
    Renderer.renderClippedImage(_image, spriteLocation.lx, spriteLocation.ly, _spriteSheetDefinition.spriteWidth, _spriteSheetDefinition.spriteHeight,
        x, y, width, height);

  }

}
