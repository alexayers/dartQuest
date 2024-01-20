import '../engine/application/game_screen.dart';
import '../engine/application/teeny_tiny_two_dee.dart';
import 'screens/outside_screen.dart';
import 'screens/press_enter_screen.dart';
import 'screens/render_test_screen.dart';
import 'screens/screens.dart';

class Game extends TeenyTinyTwoDeeApp {
  void init() {
    Map<String, GameScreen> gameScreens = {};

    gameScreens[Screens.pressEnter.name] = PressEnterScreen();
    gameScreens[Screens.outside.name] = OutsideScreen();
    gameScreens[Screens.renderTest.name] = RenderTestScreen();

    super.run(gameScreens, Screens.outside.name);
  }
}
