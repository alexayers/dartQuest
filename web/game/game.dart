import '../engine/application/gameScreen.dart';
import '../engine/application/teenyTinyTwoDee.dart';
import 'screens/mainMenuScreen.dart';
import 'screens/outsideScreen.dart';
import 'screens/pressEnterScreen.dart';
import 'screens/screens.dart';
import 'screens/testScreen.dart';

class Game extends TeenyTinyTwoDeeApp {
  void init() {
    Map<String, GameScreen> gameScreens = {};

    gameScreens[Screens.pressEnter.name] = PressEnterScreen();
    gameScreens[Screens.outside.name] = OutsideScreen();


    super.run(gameScreens, Screens.outside.name);
  }
}
