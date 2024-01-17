import '../engine/application/gameScreen.dart';
import '../engine/application/teenyTinyTwoDee.dart';
import 'screens/outsideScreen.dart';
import 'screens/pressEnterScreen.dart';
import 'screens/renderTestScreen.dart';
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
