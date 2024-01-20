import '../renderer.dart';
import '../sprite.dart';
import 'camera.dart';

class TransparentWall {
  int xMap;
  int yMap;
  int side;
  int xScreen;
  Camera camera;
  List<num> cameraXCoords;
  Sprite sprite;

  TransparentWall(this.sprite, this.camera, this.xMap, this.yMap, this.side,
      this.xScreen, this.cameraXCoords);

  num getRayDir(int x) {
    if (side == 1) {
      return camera.yDir + camera.yPlane * cameraXCoords[x];
    } else {
      return camera.xDir + camera.xPlane * cameraXCoords[x];
    }
  }

  num getPrepDist(int x) {
    int step = 1;
    num rayDir = getRayDir(x);

    if (rayDir < 0) {
      step = -1;
    }

    if (side == 1) {
      return (yMap - camera.yPos + (0.5 * step) + (1 - step) / 2) / rayDir;
    } else {
      return (xMap - camera.xPos + (0.5 * step) + (1 - step) / 2) / rayDir;
    }
  }

  void draw() {
    Renderer.saveContext();
    Renderer.setAlpha(0.8);

    num perpDist = getPrepDist(xScreen);
    int lineHeight = (Renderer.getCanvasHeight() / perpDist).round();
    num drawStart = -lineHeight / 2 + Renderer.getCanvasHeight() / 2;

    num wallX = 0;
    if (side == 0) {
      wallX = camera.yPos + perpDist * getRayDir(xScreen);
    } else if (side == 1) {
      wallX = camera.xPos + perpDist * getRayDir(xScreen);
    }

    wallX -= wallX.floor();


    int texX = (wallX * sprite.image.width!).floor();
    Renderer.renderClippedImage(sprite.image, texX, 0, 1, sprite.image.height!,
        xScreen, drawStart, 1, lineHeight);

    Renderer.restoreContext();
  }
}
