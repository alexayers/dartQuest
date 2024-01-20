import 'dart:html';

import 'renderer.dart';

class Sprite {
  num width;
  num height;
  num x = 0;
  num y = 0;
  num z = 0;
  ImageElement image;

  Sprite(this.width, this.height, String imageFile) : image = ImageElement() {
    image.src = imageFile;
  }

  void render(num x, num y, int width, int height, [bool flip = false]) {
    Renderer.renderImage(image, x, y, width, height, flip);
  }



}
