import '../../engine/application/gameScreen.dart';
import '../../engine/audio/audioManager.dart';
import '../../engine/gameEvent/gameEventBus.dart';
import '../../engine/gameEvent/screenChangeEvent.dart';
import '../../engine/input/keyboard.dart';
import '../../engine/input/mouse.dart';
import '../../engine/primitives/color.dart';
import '../../engine/rendering/font.dart';
import '../../engine/rendering/renderer.dart';
import '../../engine/utils/mathUtils.dart';
import '../../engine/utils/timerUtil.dart';
import '../../fonts.dart';
import 'screens.dart';

class MainMenuScreen implements GameScreen {
  int _currentMenuIdx = 0;
  final List<String> _menuItems = [];
  final TimerUtil _timer = TimerUtil(100);
  num _satX = 0;
  final TimerUtil _blinkTimer = TimerUtil(1000);
  AudioManager audioManager = AudioManager.instance;

  @override
  void init() {

    _menuItems.add("Begin");
    _menuItems.add("Quit");
    _timer.start(100);
  }

  @override
  void keyboard() {
    if (!_timer.hasTimePassed()) {
      return;
    }

    _timer.reset();

    if (isKeyDown(keyboardInput.up)) {
      _currentMenuIdx--;

      if (_currentMenuIdx < 0) {
        _currentMenuIdx = _menuItems.length - 1;
      }

      audioManager.play("boop");
    }

    if (isKeyDown(keyboardInput.down)) {
      _currentMenuIdx++;

      if (_currentMenuIdx == _menuItems.length) {
        _currentMenuIdx = 0;
      }

      audioManager.play("boop");
    }
    if (isKeyDown(keyboardInput.enter)) {
      if (_currentMenuIdx == 0) {
        GameEventBus.publish(ScreenChangeEvent(Screens.testScreen.name));
      }
    }
  }

  @override
  void logicLoop() {
    keyboard();
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
    audioManager.play("theme");
  }

  @override
  void onExit() {
    audioManager.stop("theme");
  }

  @override
  void renderLoop() {
    Renderer.rect(0, 0, Renderer.getCanvasWidth(), Renderer.getCanvasHeight(),
        Colors.black);

    Renderer.circle(450, 300, 100, Color(14, 34, 2));

    Renderer.circle(600 - (_satX / 10), 100, 5, Color(255, 255, 255));
    Renderer.circle(600 - (_satX / 10), 100, 10, Color(32, 116, 189, 0.245));

    Renderer.circle(100, 100, 400, Color(138, 34, 14));
    Renderer.circle(105, 100, 410,
        Color(138, 34, 14, 0.123 + MathUtils.getRandomBetween(1, 5) / 100));

    Renderer.print("Alex Ayers Presents:", 10, 115,
        Font(Fonts.oxaniumBold.name, 20, Colors.white));
    Renderer.print(
        "The Outpost", 10, 200, Font(Fonts.oxaniumBold.name, 90, Colors.white));

    int offsetY = 150;

    for (int i = 0; i < _menuItems.length; i++) {
      if (i == _currentMenuIdx) {
        Renderer.print(
            _menuItems[i],
            Renderer.getCanvasWidth() - 200,
            Renderer.getCanvasHeight() - offsetY,
            Font(Fonts.oxanium.name, 35, Colors.white));
      } else {
        Renderer.print(
            _menuItems[i],
            Renderer.getCanvasWidth() - 200,
            Renderer.getCanvasHeight() - offsetY,
            Font(Fonts.oxanium.name, 35, Color(138, 34, 14)));
      }

      offsetY -= 50;
    }

    for (int i = 0; i < Renderer.getCanvasHeight(); i += 4) {
      Renderer.line(
          0, i, Renderer.getCanvasWidth(), i, 0.85, Color(0, 0, 0, 0.14));
    }

    Renderer.rect(_satX, 300, 4, 4, Colors.white);

    if (_blinkTimer.hasTimePassed()) {
      Renderer.rect(_satX - 2, 298, 8, 8, Color(255, 255, 255, 0.54));
      _blinkTimer.reset();
    }

    _satX += 0.25;

    if (_satX > Renderer.getCanvasWidth()) {
      _satX = -100;
    }
  }
}
