

import '../../engine/application/gameScreen.dart';
import '../../engine/input/mouse.dart';
import '../../engine/rendering/spriteSheet.dart';

class RenderTestScreen implements GameScreen {

  SpriteSheet spriteSheet = SpriteSheet(SpriteSheetDefinition("../../assets/images/outside/tileSetOutside.png",
      [
        "trees", "bush", "dirt", "berries", //
        "waterFall1", "waterFall2", "waterFall3", "waterFall4",
        "shopSign", "shopDoor", "shopWindow", "showWall",
        "stoneWall", "caveEntrance"
      ], 16, 16));

  @override
  void init() {

  }

  @override
  void keyboard() {
    // TODO: implement keyboard
  }

  @override
  void logicLoop() {
    // TODO: implement logicLoop
  }

  @override
  void mouseClick(double x, double y, MouseButton mouseButton) {
    // TODO: implement mouseClick
  }

  @override
  void mouseMove(double x, double y) {
    // TODO: implement mouseMove
  }

  @override
  void onEnter() {
    // TODO: implement onEnter
  }

  @override
  void onExit() {
    // TODO: implement onExit
  }

  @override
  void renderLoop() {
 //   spriteSheet.render("stoneWall", 150, 150, 64, 64);
  }

}
