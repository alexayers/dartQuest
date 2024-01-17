import '../../../engine/ecs/gameEntity.dart';
import '../../../engine/ecs/gameEntityRegistry.dart';
import '../../../engine/ecs/gameRenderSystem.dart';
import '../../../engine/gameEvent/gameEventBus.dart';
import '../../../engine/gameEvent/screenChangeEvent.dart';
import '../../../engine/logger/logger.dart';
import '../../../engine/primitives/color.dart';
import '../../../engine/rendering/font.dart';
import '../../../engine/rendering/renderer.dart';
import '../../../fonts.dart';
import '../../screens/screens.dart';

class DeathRenderSystem implements GameRenderSystem {

  GameEntityRegistry gameEntityRegistry = GameEntityRegistry.instance;
  num _alphaFade = 1;
  num _fadeTick = 0;
  final num _fadeRate = 10;


  @override
  void process() {
    GameEntity player = gameEntityRegistry.getSingleton("player");

    if (!player.hasComponent("dead")) {
        return;
    }

    logger(LogType.debug, "dying");


    _alphaFade += 0.01;

    if (_alphaFade > 0.1) {

      _fadeTick++;

      if (_fadeTick == _fadeRate) {
        _fadeTick = 0;
        _alphaFade -= 0.09;
        GameEventBus.publish(ScreenChangeEvent(Screens.pressEnter.name));
      }



      Renderer.print("You have died", 60, 250, Font(
        Fonts.oxaniumBold.name,
        100,
        Color(255, 255, 255,_alphaFade)
      ));
    }


  }

}
