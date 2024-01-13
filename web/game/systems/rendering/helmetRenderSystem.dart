import '../../../engine/ecs/components/cameraComponent.dart';
import '../../../engine/ecs/gameEntity.dart';
import '../../../engine/ecs/gameEntityRegistry.dart';
import '../../../engine/ecs/gameRenderSystem.dart';
import '../../../engine/primitives/color.dart';
import '../../../engine/rendering/font.dart';
import '../../../engine/rendering/rayCaster/worldMap.dart';
import '../../../engine/rendering/renderer.dart';
import '../../../engine/rendering/sprite.dart';
import '../../../fonts.dart';
import '../../components/canHaveMessageComponent.dart';

class HelmetRenderSystem implements GameRenderSystem {
  final GameEntityRegistry _gameEntityRegistry = GameEntityRegistry.instance;
  int _visorLine = 0;
  final WorldMap _world = WorldMap.instance;
  final Sprite _ore = Sprite(0, 0, "../../assets/images/rock.png");

  @override
  void process() {
    GameEntity player = _gameEntityRegistry.getSingleton("player");

    if (player.hasComponent("dead")) {
      return;
    }

    CameraComponent camera = player.getComponent("camera") as CameraComponent;

    renderDamaged(camera);
    renderMessage(camera);

    renderHelmetEffect();
  }

  void renderHelmetEffect() {
    Color lineColor = Color(255, 20, 255, 0.03);
    Color scanLine = Color(255, 20, 255, 0.02);

    for (int y = 0; y < Renderer.getCanvasHeight(); y += 64) {
      Renderer.line(0, y, Renderer.getCanvasWidth(), y, 1, lineColor);
    }

    for (int x = 0; x < Renderer.getCanvasWidth(); x += 64) {
      Renderer.line(x, 0, x, Renderer.getCanvasHeight(), 1, lineColor);
    }

    Renderer.rect(0, _visorLine, Renderer.getCanvasWidth(), 64, scanLine);
    _visorLine += 10;

    if (_visorLine > Renderer.getCanvasHeight()) {
      _visorLine = -100;
    }
  }

  void renderDamaged(CameraComponent camera) {
    int checkMapX = (camera.camera.xPos + camera.camera.xDir).floor();
    int checkMapY = (camera.camera.yPos + camera.camera.yDir).floor();

    GameEntity gameEntity = _world.getEntityAtPosition(checkMapX, checkMapY);

    if (gameEntity.hasComponent("damaged")) {
      Renderer.rect((Renderer.getCanvasWidth() / 2) - 10,
          (Renderer.getCanvasHeight() / 2) - 20, 105, 40, Colors.black);


      Renderer.print("Damaged", (Renderer.getCanvasWidth() / 2) as int, (Renderer.getCanvasHeight() / 2) as int, Font(
        Fonts.oxanium.name,
        20,
        Colors.white
      ));


    }
  }

  void renderMessage(CameraComponent camera) {
    int checkMapX = (camera.camera.xPos + camera.camera.xDir).floor();
    int checkMapY = (camera.camera.yPos + camera.camera.yDir).floor();

    GameEntity gameEntity = _world.getEntityAtPosition(checkMapX, checkMapY);

    if (gameEntity.hasComponent("canHaveMessage")) {
      CanHaveMessageComponent canHaveMessage =
          gameEntity.getComponent("canHaveMessage") as CanHaveMessageComponent;

      canHaveMessage.callback();
    }
  }
}
