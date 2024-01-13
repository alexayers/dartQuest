import '../../../primitives/color.dart';
import '../../../rendering/rayCaster/rayCaster.dart';
import '../../../rendering/rayCaster/renderPerformance.dart';
import '../../../rendering/rayCaster/worldMap.dart';
import '../../../rendering/renderer.dart';
import '../../components/cameraComponent.dart';
import '../../gameEntity.dart';
import '../../gameEntityRegistry.dart';
import '../../gameRenderSystem.dart';

class RayCastRenderSystem implements GameRenderSystem {
  final RayCaster _rayCaster = RayCaster();
  final WorldMap _worldMap = WorldMap.instance;
  final GameEntityRegistry _gameEntityRegistry = GameEntityRegistry.instance;

  @override
  void process() {
    GameEntity player = _gameEntityRegistry.getSingleton("player");
    RenderPerformance.updateFrameTimes();
    _worldMap.moveDoors();

    CameraComponent camera = player.getComponent("camera") as CameraComponent;

    _rayCaster.drawSkyBox(Color(74, 67, 57), Color(40, 40, 40));

    for (int x = 0; x < Renderer.getCanvasWidth(); x++) {
      _rayCaster.drawWall(camera.camera, x);
    }

    _rayCaster.drawSpritesAndTransparentWalls(camera.camera);
    _rayCaster.flushBuffer();
  }
}
