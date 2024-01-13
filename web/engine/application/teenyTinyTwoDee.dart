import 'dart:html';

import '../gameEvent/gameEvent.dart';
import '../gameEvent/gameEventBus.dart';
import '../gameEvent/screenChangeEvent.dart';
import '../input/keyboard.dart';
import '../logger/logger.dart';
import '../rendering/renderer.dart';
import 'gameScreen.dart';
import 'globalState.dart';

class TeenyTinyTwoDeeApp {
  Map<String, GameScreen> _gameScreens = {};
  String? _currentScreen;
  final int framesPerSecond = 60;

  TeenyTinyTwoDeeApp() {
    // ConfigurationManager.init(cfg);
    logger(LogType.info, "TeenyTinyTwoDeeApp - Dart V: 0.0.1");

    window.onKeyDown.listen((KeyboardEvent event) {
      event.preventDefault();
      GameEventBus.publish(GameEvent("keyboardDownEvent", event));
    });

    window.onKeyUp.listen((KeyboardEvent event) {
      event.preventDefault();
      GameEventBus.publish(GameEvent("keyboardUpEvent", event));
    });

    GameEventBus.register("keyboardDownEvent", (GameEvent gameEvent) {
      GlobalState.createState("KEY_${gameEvent.payload.keyCode}", true);
    });

    GameEventBus.register("keyboardUpEvent", (GameEvent gameEvent) {
      GlobalState.createState("KEY_${gameEvent.payload.keyCode}", false);
    });
  }

  void run(Map<String, GameScreen> gameScreens, String currentScreen) {
    Renderer.init();

    _gameScreens = gameScreens;

    _gameScreens.forEach((key, gameScreen) {
      gameScreen.init();
    });

    GameEventBus.register("__CHANGE_SCREEN__", (GameEvent gameEvent) {
      logger(LogType.info, gameEvent.payload);

      if (_currentScreen != null) {
        _gameScreens[_currentScreen]?.onExit();
      }

      flushKeys();
      _currentScreen = gameEvent.payload;
      _gameScreens[_currentScreen]?.onEnter();
    });

    GameEventBus.publish(ScreenChangeEvent(currentScreen));
    gameLoop();
  }

  void gameLoop() {
    _gameScreens[_currentScreen]?.logicLoop();

    Renderer.clearScreen();

    _gameScreens[_currentScreen]?.renderLoop();

    Future.delayed(Duration(milliseconds: 1000 ~/ framesPerSecond), () {
      window.animationFrame.then((_) => gameLoop());
    });
  }
}
