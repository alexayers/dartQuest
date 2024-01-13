import '../input/mouse.dart';

abstract class GameScreen {
  void init();

  void onEnter();

  void onExit();

  void logicLoop();

  void renderLoop();

  void keyboard();

  void mouseClick(double x, double y, MouseButton mouseButton);

  void mouseMove(double x, double y);
}
