import '../engine/application/gameScreen.dart';
import '../engine/application/teenyTinyTwoDee.dart';
import 'screens/mainMenuScreen.dart';
import 'screens/screens.dart';
import 'screens/testScreen.dart';

class Game extends TeenyTinyTwoDeeApp {
  void init() {
    Map<String, GameScreen> gameScreens = {};

    gameScreens[Screens.mainMenu.name] = MainMenuScreen();
    gameScreens[Screens.testScreen.name] = TestScreen();


    super.run(gameScreens, Screens.testScreen.name);
  }
}
