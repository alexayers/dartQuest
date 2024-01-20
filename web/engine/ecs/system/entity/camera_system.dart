import '../../../rendering/rayCaster/render_performance.dart';
import '../../components/camera_component.dart';
import '../../components/velocity_component.dart';
import '../../game_entity.dart';
import '../../game_system.dart';

class CameraSystem implements GameSystem {
  final double _turnSpeed = 0.038;

  @override
  void processEntity(GameEntity gameEntity) {
    double turnSpeed = _turnSpeed * RenderPerformance.deltaTime;

    CameraComponent camera =
        gameEntity.getComponent("camera") as CameraComponent;
    VelocityComponent velocity =
        gameEntity.getComponent("velocity") as VelocityComponent;

    camera.camera.move(velocity.velX, velocity.velY);

    if (velocity.rotateRight) {
      camera.camera.rotate(-turnSpeed);
    }

    if (velocity.rotateLeft) {
      camera.camera.rotate(turnSpeed);
    }

    velocity.velX = 0;
    velocity.velY = 0;
    velocity.rotateLeft = false;
    velocity.rotateRight = false;
  }

  @override
  void removeIfPresent(GameEntity gameEntity) {
    // TODO: implement removeIfPresent
  }

  @override
  bool shouldRun(GameEntity gameEntity) {
    return gameEntity.hasComponent("camera");
  }
}
